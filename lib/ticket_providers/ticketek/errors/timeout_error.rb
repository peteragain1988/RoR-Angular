class TicketProviders::Ticketek::Errors::TimeoutError < StandardError
  def initialize(id)
    super("Request timed out for ticket: #{id}")
  end
end