namespace :db do
  namespace :workbasket_scripts do
    desc "Existing data: set published status for already imported data"
    task set_proper_states_for_imported_data: :environment do
      ::WorkbasketScripts::SetPublishedStatusForImportedData.new.run
    end
  end
end
