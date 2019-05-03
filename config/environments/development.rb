Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true
  config.cache_store = :redis_store, { url: "redis://127.0.0.1:6379/0" }

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Mailcatcher configuration.
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :letter_opener

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers.
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets.
  config.assets.compress = false

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Expands the lines which load the assets.
  config.assets.debug = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

  # Configure Rails.logger to log to both STDOUT and development.log file.
  config.log_level = :debug
end
