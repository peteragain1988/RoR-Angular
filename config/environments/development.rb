Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.preview_path = "#{Rails.root}/tests/mailers/previews"

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # config.cache_store = :dalli_store, {namespace: :thms, expires_in: 120.minutes, compress: true, pool: 5}



  config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  #     authentication: :plain,
  #     address: 'smtp.mailgun.org',
  #     ssl: true,
  #     port: 465,
  #     domain: 'mg.turnkeyhospitality.com.au',
  #     user_name: 'postmaster@mg.turnkeyhospitality.com.au',
  #     password: '6ng-x39pz3t3'
  # }


  config.action_mailer.smtp_settings = {
      authentication: :plain,
      address: 'smtp.gmail.com',
      ssl: true,
      port: 465,
      domain: 'turnkeyhospitality.com.au',
      user_name: 'cs@turnkeyhospitality.com.au',
      password: 'DuOXf102cNRFShGq'
  }


  # config.paperclip_defaults = {
  #     :storage => :s3,
  #     :s3_credentials => {
  #         :bucket => ENV['S3_BUCKET_NAME'],
  #         :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  #         :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  #     }
  # }

  config.paperclip_defaults = {
      :storage => :s3,
      :s3_protocol => :https,
      :s3_credentials => {
          :bucket => 'eventhub-development',
          :access_key_id => 'AKIAIDZ2ORONMTSE7EIQ',
          :secret_access_key => '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'
      }
  }

end