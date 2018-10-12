require 'workbasket_scripts/set_published_status_for_imported_data'

class SetupPublishedStatusForImportedRecordsWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default, retry: 5

  def perform
    ::WorkbasketScripts::SetPublishedStatusForImportedData.run
  end
end
