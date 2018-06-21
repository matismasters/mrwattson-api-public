Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.log_level = :debug
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
  config.action_mailer.default_url_options = { host: 'mrwattson-api.herokuapp.com' }
  config.action_mailer.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: 587, # ports 587 and 2525 are also supported with STARTTLS
    enable_starttls_auto: true, # detects and uses STARTTLS
    user_name: ENV['SENDGRID_USERNAME'],
    password: ENV['SENDGRID_PASSWORD'], # SMTP password is any valid API key, when user_name is "apikey".
    authentication: 'login',
    domain: 'mrwattson.com', # your domain to identify your server when connecting
  }
end
