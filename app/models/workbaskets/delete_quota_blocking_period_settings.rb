module Workbaskets
  class DeleteQuotaBlockingPeriodSettings < Sequel::Model(:delete_quota_blocking_period_workbasket_settings)
    include ::WorkbasketHelpers::SettingsBase
    extend ActiveSupport::Concern

    def collection_models
      %w(
        QuotaBlockingPeriod
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
