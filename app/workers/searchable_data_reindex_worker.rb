require 'measures/refresh_cache'

class SearchableDataReindexWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default, retry: 5

  def perform
    if Rails.env.production?
      ::Measures::ReindexSearchableData.new.run
    end
  end
end
