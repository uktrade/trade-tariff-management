module Workbaskets
  class CreateRegulationSettings < Sequel::Model(:create_regulation_workbasket_settings)

    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
        BaseRegulation
      )
    end

    def settings
      main_step_settings_jsonb
    end

  end
end
