class TicketProviders::Ticketek::Errors::UnauthorisedError < StandardError
  def initialize(id)
    super("Received a 401 Un-authorised for ticket: #{id}")
  end
end