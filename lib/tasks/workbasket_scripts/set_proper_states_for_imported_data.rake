require 'workbasket_scripts/set_published_status_for_imported_data'

namespace :db do
  namespace :workbasket_scripts do
    desc "Existing data: set published status for already imported data"
    task set_proper_states_for_imported_data: :environment do
      ::WorkbasketScripts::SetPublishedStatusForImportedData.run
    end
  end
end
