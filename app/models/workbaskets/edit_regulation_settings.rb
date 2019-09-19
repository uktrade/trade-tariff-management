module Workbaskets
  class EditRegulationSettings < Sequel::Model(:edit_regulation_workbasket_settings)
    include ::WorkbasketHelpers::SettingsBase

    one_to_one :original_regulation, class: :BaseRegulation

    def collection_models
      %w(
        BaseRegulation
      )
    end

    def settings
    end

    def measure_sids_jsonb
      '{}'
    end

    def main_step_settings_jsonb
      '{}'
    end

  end
end
