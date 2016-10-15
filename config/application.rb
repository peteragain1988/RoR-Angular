require File.expand_path('../boot', __FILE__)
# ROADIE_I_KNOW_ABOUT_VERSION_3 = true
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require 'action_view/railtie'
# require 'sprockets/railtie'
# require 'postgres_ext/serializers'

## Jack up the password cost, heaps...
require 'bcrypt'
silence_warnings do
  BCrypt::Engine::DEFAULT_COST = 14
  I18n.enforce_available_locales = false
end

# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ThmsRails
  class Application < Rails::Application
    # config.autoload_paths += %W(#{config.root}/lib)
    ActiveModel::Serializer.root = false
    ActiveModel::ArraySerializer.root = false

    config.assets.precompile += %w( framework.js )
    config.filter_parameters += [:password, :password_confirmation, :otp_secret]
    config.eager_load_paths += ["#{Rails.root}/lib"]
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.action_view.cache_template_loading = false

    config.generators do |g|
      g.test_framework      :rspec, fixture: true
      g.fixture_replacement :fabrication
    end


  end
end
