class TicketProviders::Ticketek::API

  def initialize(ticket_id)
    @api_options = TicketProviders::Ticketek::Configuration.get
    @ticket = Ticket.find ticket_id
    authenticate unless authenticated?
  end

  def authenticated?
    TicketProviders::Ticketek::AuthenticationToken.get
  end

  def authenticate
    TicketProviders::Ticketek::AuthenticationToken.authenticate
  end


  def request
    suite_number = @ticket.facility_name.gsub(/\D/,'')
    
    if @ticket.facility_type == ""
      ticketing_event_code = @ticket.ticketing_event_code
    else  
      if @ticket.facility_type == "Suite"
        ticketing_event_code = @ticket.ticketing_event_code
      elsif @ticket.facility_type == "Box"
        ticketing_event_code = @ticket.ticketing_event_code_box
      elsif @ticket.facility_type == "CLS"
        ticketing_event_code = @ticket.ticketing_event_code_cl
      end
    end
    
    if Rails.env.production?
      http_request = Typhoeus::Request.new(
            "#{@api_options[:api_url]}/Tickets",
            method: :post,
            headers: {
                Authorization: "Bearer #{authenticated?}"
            },
            body: {
                :EventCode => ticketing_event_code,
                :FirstName => "Suite #{suite_number}",
                :SeatCode => "#{suite_number}/#{@ticket.seat}",
                :LastName => @ticket.client_name,
                :SectionCode => "SSUITE#{suite_number}",
                :Email => "#{@api_options[:email_user]}@#{@ticket.reference_number}.mg.eventhub.com.au"
            }
      )
    elsif Rails.env.development?
      http_request = Typhoeus::Request.new(
          "#{@api_options[:api_url]}/Tickets",
          method: :post,
          headers: {
              Authorization: "Bearer #{authenticated?}"
          },
          body: {
              EventCode: 'ESAS2015700',
              SectionCode: 'S3000',
              SeatCode: '',
              Email: 'janiskaulins44@gmail.com',
              FirstName: 'Janis',
              LastName: 'Kaulins'
          }
      )
    end

    http_request.on_complete do |response|
      if response.code == 201
        @ticket.update_attributes({
          ticketek_id: response.body.gsub('"', ''),
          status: :transiting
        })
      else handle_error response end

    end

    http_request.run
  end

  def reissue
    http_request = Typhoeus::Request.new(
        "#{@api_options[:api_url]}/Tickets/#{@ticket.ticketek_id}",
        method: :post,
        headers: { Authorization: "Bearer #{authenticated?}" }
    )

    http_request.on_complete do |response|
      if response.code == 204
        puts "Ticket #{@ticket.ticketek_id} Reissued"
      else
        handle_error response
      end
    end

    http_request.run
  end

  def cancel
    http_request = Typhoeus::Request.new(
        "#{@api_options[:api_url]}/Tickets/#{@ticket.ticketek_id}",
        method: :delete,
        headers: { Authorization: "Bearer #{authenticated?}" }
    )

    http_request.on_complete do |response|
      if response.code == 204
        @ticket.cancelled_succesfully
      else
        handle_error response
      end
    end

    http_request.run
  end


  def handle_error(response)
    if response.timed_out?
      raise TicketProviders::Ticketek::Errors::TimeoutError.new @ticket.id
    elsif response.code == 401
      raise TicketProviders::Ticketek::Errors::UnauthorisedError.new @ticket.id
    # authenticate
    # request
    elsif response.code == 400
      raise TicketProviders::Ticketek::Errors::BadRequestError.new @ticket.id
    else
      raise TicketProviders::Ticketek::Errors::GenericError.new @ticket, response
    end
  end
end