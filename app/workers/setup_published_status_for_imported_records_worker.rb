require 'measures/refresh_cache'

class SetupPublishedStatusForImportedRecordsWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default, retry: 5

  def perform
    ::WorkbasketScripts::SetPublishedStatusForImportedData.run
  end
end
