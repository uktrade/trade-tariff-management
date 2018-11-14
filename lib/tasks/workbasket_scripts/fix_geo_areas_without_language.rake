require 'workbasket_scripts/fix_geo_areas_without_language'

namespace :db do
  namespace :workbasket_scripts do
    desc "Existing data: fix geo areas without language"
    task fix_geo_areas_without_language: :environment do
      ::WorkbasketScripts::FixGeoAreasWithoutLanguage.run
    end
  end
end
