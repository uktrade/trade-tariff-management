require 'redis_lock'
require 'ostruct'

module TradeTariffBackend
  autoload :Auditor,         'trade_tariff_backend/auditor'
  autoload :DataMigration,   'trade_tariff_backend/data_migration'
  autoload :DataMigrator,    'trade_tariff_backend/data_migrator'
  autoload :Mailer,          'trade_tariff_backend/mailer'
  autoload :NumberFormatter, 'trade_tariff_backend/number_formatter'
  autoload :Validator,       'trade_tariff_backend/validator'

  class << self
    def configure
      yield self
    end

    # Lock key used for DB locks to keep just one instance of synchronizer
    # running in cluster environment
    def db_lock_key
      'tariff-lock'
    end

    def log_formatter
      Proc.new {|severity, time, progname, msg| "#{time.strftime('%Y-%m-%dT%H:%M:%S.%L %z')} #{sprintf('%5s', severity)} #{msg}\n" }
    end

    # Email of the user who receives all info/error notifications
    def from_email
      ENV.fetch("TARIFF_FROM_EMAIL")
    end

    # Email of the user who receives all info/error notifications
    def admin_email
      ENV.fetch("TARIFF_SYNC_EMAIL")
    end

    def platform
      Rails.env
    end

    def deployed_environment
      MAILER_ENV
    end

    def govuk_app_name
      ENV["GOVUK_APP_NAME"]
    end

    def production?
      ENV["GOVUK_APP_DOMAIN"] == "tariff-management-production.cloudapps.digital"
    end

    def staging?
      ENV["GOVUK_APP_DOMAIN"] == "tariffs-uat.cloudapps.digital"
    end

    def development?
      ENV["GOVUK_APP_DOMAIN"] == "tariffs-dev"
    end

    def data_migration_path
      File.join(Rails.root, 'db', 'data_migrations')
    end

    def with_redis_lock(lock_name = db_lock_key, &block)
      lock = RedisLock.new(RedisLockDb.redis, lock_name)
      lock.lock &block
    end

    # Number of changes to fetch for Commodity/Heading/Chapter
    def change_count
      10
    end

    def number_formatter
      @number_formatter ||= TradeTariffBackend::NumberFormatter.new
    end

    def model_serializer_for(model)
      "#{model}Serializer".constantize
    end
  end
end
