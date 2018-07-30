module Workbaskets
  class CreateQuotaSettings < Sequel::Model(:create_quota_workbasket_settings)

    include ::WorkbasketHelpers::SettingsBase

    def configure_quota_step_settings
      JSON.parse(configure_quota_step_settings_jsonb)
    end

    def conditions_footnotes_step_settings
      JSON.parse(conditions_footnotes_step_settings_jsonb)
    end
  end
end
