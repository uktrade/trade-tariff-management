class TestMailer < ActionMailer::Base

  default from: TradeTariffBackend.from_email

  def welcome(email)
    @email = email
    @subject = "[SIGNON DEV APP] test mailer!"

    mail to: @email, subject: @subject
  end
end
