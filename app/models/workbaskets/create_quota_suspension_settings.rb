module Workbaskets
  class CreateQuotaSuspensionSettings < Sequel::Model(:create_quota_suspension_workbasket_settings)
    include ::WorkbasketHelpers::SettingsBase
    extend ActiveSupport::Concern

    attr_accessor :description,
                  :quota_definition_sid,
                  :start_date,
                  :end_date

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

    def decorate
      QuotaAssociationSettingsDecorator.decorate(self)
    end
  end
end
