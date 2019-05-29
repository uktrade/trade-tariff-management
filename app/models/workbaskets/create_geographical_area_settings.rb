module Workbaskets
  class CreateGeographicalAreaSettings < Sequel::Model(:create_geographical_area_workbasket_settings)
    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
        GeographicalArea
        GeographicalAreaDescriptionPeriod
        GeographicalAreaDescription
        GeographicalAreaMembership
      )
    end

    def settings
      JSON.parse(main_step_settings_jsonb)
    end

    def measure_sids_jsonb
      '{}'
    end

    def validity_start_date
      settings["validity_start_date"]
    end

    def validity_end_date
      settings["validity_end_date"]
    end

    def description
      settings["description"]
    end

    def geographical_area_id
      settings["geographical_area_id"]
    end

    def geographical_code
      settings["geographical_code"]
    end
  end
end
