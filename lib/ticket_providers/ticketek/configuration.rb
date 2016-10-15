class TicketProviders::Ticketek::Configuration
  include Singleton

  def self.get
    @config ||= YAML.load(File.read("#{Rails.root}/config/ticketek_tickets.yml"))
    @config[Rails.env.to_sym]
  end
end

