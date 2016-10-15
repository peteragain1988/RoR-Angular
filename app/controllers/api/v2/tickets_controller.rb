class Api::V2::TicketsController < Api::V2::ApplicationController
  skip_filter :authenticate_user, only: :create
  skip_before_filter :authenticate_user, :only => [:anz_index, :pdf_download]
  # load_and_authorize_resource
  # skip_load_and_authorize_resource only: [:index, :create, :manual_create]
  # before_filter :ensure_administrator_only, only: [:manual, :manual_create]
  def index
    @events = Event.includes(
      dates: [
          tickets: [:facility]
      ]
    ).merge(Ticket.accessible_by current_ability).merge(EventDate.not_finished).references(:tickets)
    render 'index'
  end
  
  def anz_index
    
    auth_token = params[:auth_token]
    vtoken = verify_token(auth_token)
    
    if vtoken
      
      @employee = Employee.find_by_email("#{vtoken[0]}")
        
      if vtoken[1].to_i >= Time.new.to_i
        if @employee
                            
          #.merge(Ticket.available)
          if(params.has_key?(:facility_name))
            @facility_name = params[:facility_name]
            facility_names = "('" + params[:facility_name].gsub(/&/,"','") +"')"
          else
            @facility_name = ""
          end
          
          if @employee.venue_admin?
            client_ids = @employee.company.client_ids
            if(@facility_name != "")
              @events = Event.includes(
               dates: [
                   tickets: [:facility]
               ]
              ).merge(Ticket.available).where("tickets.client_id IN (?)", client_ids).merge(EventDate.not_finished).where("facilities.name IN #{facility_names}").references(:tickets)
            else 
              @events = Event.includes(
               dates: [
                   tickets: [:facility]
               ]
              ).merge(Ticket.available).where("tickets.client_id IN (?)", client_ids).merge(EventDate.not_finished).references(:tickets)
            end
          elsif @employee.client_admin?
            if(@facility_name != "")
              @events = Event.includes(
               dates: [
                   tickets: [:facility]
               ]
              ).merge(Ticket.available).where("tickets.client_id = '#{@employee.company_id}'").merge(EventDate.not_finished).where("facilities.name IN #{facility_names}").references(:tickets)
            else 
              @events = Event.includes(
               dates: [
                   tickets: [:facility]
               ]
              ).merge(Ticket.available).where("tickets.client_id = '#{@employee.company_id}'").merge(EventDate.not_finished).references(:tickets)
            end
          end
          
          @user_id = @employee.id
          @user_email = vtoken[0]
          
          render
        else
          render json: {token_flag: 1, err_msg: "Email Not Found. Authentication Failed."}
        end
      else
        if @employee
          render json: {token_flag: 2, err_msg: "Session Expired. Authentication Failed."}
        else
          render json: {token_flag: 1, err_msg: "Email Not Found. Authentication Failed."}
        end
      end
    else
      render json: {token_flag: 3, err_msg: "Invalid Token. Authentication Failed."}
    end
  end
  
  
  def pdf_download
    @ticket =  Ticket.find(params[:id])
    @storage_type = @ticket.storage_type
    
    if @storage_type == "remote"
      @file_name = @ticket.pdf.url
      require 'open-uri'
      url = @file_name
      begin
        data = open(url).read
        send_data data, disposition: 'attachment', type: 'application/pdf', filename: @ticket.pdf_file_name
      rescue
        render json: {result: "File Not Exists"}
      end
      
    elsif @storage_type == "local"
      @file_name = @ticket.file_name
      if File.exist?(Rails.public_path+"tickets/"+@file_name)
        data=File.read(Rails.public_path+"tickets/"+@file_name)
        filename = @file_name.rpartition("/").last
        send_data data, disposition: 'attachment', type: 'application/pdf', filename: filename
        
        #send_file Rails.public_path+"tickets/"+@file_name, type: 'application/pdf', disposition: 'inline', url_based_filename: true
      else
        render json: {result: "File Not Exists"} 
      end
      
    else
      render json: {result: "File Not Exists"} 
    end
    
  end


  def manual
    # @inventories = Inventory.joins(:client).includes(facility:[:company], event_date: [:event], confirmed_inventory_option:[]).where("companies.config ->> 'ticket_type' = 'ezyticket'").all
    @inventories = Inventory.joins(:client).includes(facility:[:company], tickets:[]).where("companies.config ->> 'ticket_type' = 'ezyticket' AND lower(event_dates.event_period) > now()").joins(event_date:[:event])
    render json: @inventories, each_serializer: TicketCreationSerializer
  end

  # TODO Manual creation for superadmin only
  # Manual creation, pass in same vars and have it build the tickets for you not gonna remove this.
  def manual_create
    @inventory = Inventory.includes(facility:[], event_date: [:event], client:[]).find(params[:inventory_id])
    total_count = 0
    ticket_ids = [];
    ActiveRecord::Base.transaction do

      @inventory.facility.capacity.times do |seat|

        @ticket = Ticket.create([
            facility_id: @inventory.facility.id,
            event_date_id: @inventory.event_date.id,
            inventory_id: @inventory.id,
            client_id: @inventory.client.id,
            seat: seat + 1,
            row: @inventory.facility.name.gsub(/[^0-9]/,'').to_i
        ])
        total_count = total_count + 1
        ticket_ids.push @ticket[0].id
      end
    end
    render json: {total_created: total_count, index: params[:inventory_index]}
  end
  
  # This gets hit by MailGun when it receives an email
  # TODO saturday, update status, maybe make another email to myself for errors
  # TODO s3 stuff
  def create
    white_listed_senders = %w(ezytickets@softix.com confirmation@ticketek.com.au)

    if white_listed_senders.include?(params[:sender]) && params['attachment-count'].to_i > 0
      reference_id = params[:recipient].match /\d+/

      unless reference_id.nil?
        ticket = Ticket.includes(event:[]).find_by_reference_number reference_id.to_s

        unless ticket.nil?
          # TODO Ticketek only has one attachment, change this later
          file = params['attachment-1']
          # add the seat number to the end of the ticket
          filename = file.original_filename.gsub(/.pdf/,"-#{ticket.seat.to_s.rjust(2, '0')}.pdf")
          params['attachment-1'].original_filename = filename
          
          #FileUtils.move file.tempfile.path, "#{ticket_directory}/#{filename}"

          ticket.storage_type = 'remote'
          #ticket.file_name = "#{event_name}/#{event_date}/#{facility_name}/#{filename}"
          ticket.pdf = params['attachment-1']
          ticket.status = 'available'
          ticket.save
        end

      end
    end

    head :ok
  end

  private
    def ensure_administrator_only
      head :forbidden unless current_user.is_admin?
    end
  
    def generate_token(email)
      data = Base64.strict_encode64("#{email},#{(Time.now+1.year).to_i}")
      sha = OpenSSL::HMAC.hexdigest("sha256", "sharedsecret", data)
      return data+"--"+sha
    end 
    
    def verify_token(token)
      token_a = token.split("--")
      sha = OpenSSL::HMAC.hexdigest("sha256", "sharedsecret", token_a[0])
      if(token_a[1] == sha)
        begin
          data = Base64.strict_decode64(token_a[0]).split(',')
          return data
        rescue
          return false
        end
      else
        return false
      end
    end 
    
end