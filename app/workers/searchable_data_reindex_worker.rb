require 'measures/refresh_cache'

class SearchableDataReindexWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default, retry: 5

  def perform
    ::Measures::ReindexSearchableData.run
  end
end
