module Workbaskets
  class DeleteQuotaSuspensionSettings < Sequel::Model(:delete_quota_suspension_workbasket_settings)
    include ::WorkbasketHelpers::SettingsBase
    extend ActiveSupport::Concern

    def collection_models
      %w(
        QuotaSuspensionPeriod
      )
    end

    def settings
      JSON.parse(main_step_settings_jsonb)
    end

    def measure_sids_jsonb
      '{}'
    end

    def main_step_settings_jsonb
      '{}'
    end
  end
end
