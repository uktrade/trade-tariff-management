# TestWorker.perform_in(1.seconds)

class TestWorker
  include Sidekiq::Worker

  def perform
    Rails.logger.info "TestWorker: #{Time.now.to_s}"
  end
end
