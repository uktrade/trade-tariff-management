# TestWorker.perform_in(1.seconds)

class TestWorker
  include Sidekiq::Worker

  def perform
    TestMailer.welcome("rusllonrails@bitzesty.com").deliver!
  end
end
