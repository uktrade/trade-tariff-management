require 'measures/refresh_cache'

class RefreshCacheWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default, retry: 5

  def perform
    ::Measures::RefreshCache.run
  end
end
