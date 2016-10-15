source 'https://rubygems.org'
source 'http://rails-assets.org'

gem 'rails', '4.1.6'

gem 'rails-api'
gem 'custom_configuration'
gem 'jbuilder'

gem 'jwt'
gem 'bcrypt', '~> 3.1.2'
gem 'active_model_serializers'
# gem 'postgres_ext-serializers'

gem 'pg'
gem 'dalli'
gem 'connection_pool'
gem 'money-rails'

gem 'sass-rails', git: 'https://github.com/rails/sass-rails.git'
gem 'sass', '~> 3.4.5'
gem 'coffee-rails'
gem 'slim-rails'

group :production, :staging do
  gem 'uglifier'
end

# Assets
gem 'angular-rails-templates'
gem 'rails-assets-jquery'
gem 'rails-assets-lodash'
gem 'rails-assets-modernizr'
gem 'rails-assets-moment'
gem 'rails-assets-medium-editor'

gem 'rails-assets-angular', '~> 1.3.0'
gem 'rails-assets-angular-animate'
gem 'rails-assets-ng-file-upload'
gem 'rails-assets-angular-moment'
gem 'rails-assets-angular-ui-utils'
gem 'rails-assets-angular-sanitize'
gem 'rails-assets-angular-bootstrap'
gem 'rails-assets-angular-ui-router'

# deprecated
gem 'rails-assets-restangular'
gem 'rails-assets-angular-local-storage'
# deprecated

gem 'rails-assets-localforage'
gem 'rails-assets-angular-localforage'

gem 'angularjs-rails-resource', '~> 1.1.1'

# Styles
gem 'rails-assets-bourbon'
gem 'rails-assets-neat'

gem 'symmetric-encryption'
gem 'jc-validates_timeliness'

# Auth
gem 'cancancan', '~> 1.8'

#  Soft Delete
gem 'paranoia', '~> 2.0'

# Excel
gem 'axlsx'
gem 'axlsx_rails'


# Mail
gem 'roadie-rails'


group :development do
  gem 'binding_of_caller'
  gem 'better_errors'
  gem 'meta_request'
  gem 'pry-rails'
  gem 'spring'
  gem 'capistrano-rails'
  gem 'capistrano-chruby'
  gem 'capistrano-sidekiq'
  gem 'capistrano-resque', '~> 0.2.1', require: false
  gem 'thin'
  group :darwin do
    gem 'capistrano-nc', '~> 0.1', require: false
  end

end

group :development, :test do
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'guard-rspec'
  group :darwin do
    gem 'rb-fsevent', require: false
    gem 'rspec-nc', require: false
  end
  gem 'fabrication'
  gem 'faker'
end


gem 'resque', :require => 'resque/server'
gem 'sidekiq', require: 'sidekiq/web'

gem 'foreman'

# OAuth + HTTP Libraries
gem 'signet'
gem 'typhoeus'

# File Uploads
gem 'paperclip'
gem 'aws-sdk'

#  Monitoring
gem 'newrelic_rpm'

# One Time Passwords
gem 'rotp'
gem 'rqrcode_png'

# Liquid Templating
gem 'liquid'
