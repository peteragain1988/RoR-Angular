Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0', namespace: "sidekiq_eventhub_#{Rails.env}" }
  end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0', namespace: "sidekiq_eventhub_#{Rails.env}" }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  password == 'aloevera' && user == 'tangerine'
end

