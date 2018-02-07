require 'mailer_environment'

module TradeTariffBackend
  class Mailer < ActionMailer::Base
    include MailerEnvironment

    default from: TradeTariffBackend.from_email,
            to: TradeTariffBackend.admin_email
  end
end
