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
  end
end
