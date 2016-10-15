class TicketProviders::Ticketek::Errors::GenericError < StandardError
  def initialize(ticket, response)
    
    if ticket.facility.facility_type == ""
      ticketing_event_code = ticket.ticketing_event_code
    else  
      if ticket.facility.facility_type == "Suite"
        ticketing_event_code = ticket.ticketing_event_code
      elsif ticket.facility.facility_type == "Box"
        ticketing_event_code = ticket.ticketing_event_code_box
      elsif ticket.facility.facility_type == "CLS"
        ticketing_event_code = ticket.ticketing_event_code_cl
      end
    end
    
    super("Generic Error for ticket: #{ticket.id} - #{response.code} - #{ticketing_event_code} - #{ticket.facility_name} - Seat: #{ticket.seat} - #{ticket.client_name}")
  end
end