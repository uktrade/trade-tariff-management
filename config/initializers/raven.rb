if Rails.env.production?
  if defined?(Raven) && ENV["VCAP_APPLICATION"].present?
    tags = JSON.parse(ENV["VCAP_APPLICATION"])
               .except('application_uris', 'host', 'application_name', 'space_id', 'port', 'uris', 'application_version')
               .merge({ server_name: ENV["GOVUK_APP_DOMAIN"] })

    Raven.configure do |config|
      config.tags = tags
      config.environments = [ 'production' ]
    end
  else

    Raven.configure do |config|
      logger = ::Raven::Logger.new(STDOUT)
      logger.level = "error"
      config.logger = logger
      config.environments = [ 'production' ]
    end
  end
end
