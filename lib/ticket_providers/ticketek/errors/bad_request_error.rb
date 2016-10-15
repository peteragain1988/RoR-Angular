class TicketProviders::Ticketek::Errors::BadRequestError < StandardError
  def initialize(id)
    super("Received a 400 Bad Request for ticket: #{id}")
  end
end