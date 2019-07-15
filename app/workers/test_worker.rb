# TestWorker.perform_in(1.seconds)

class TestWorker
  include Sidekiq::Worker

  def perform
    TestMailer.welcome("vincent.lim@digital.trade.gov.uk").deliver!
  end
end
