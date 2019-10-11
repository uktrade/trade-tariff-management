module Workbaskets
  class CreateQuotaAssociationSettings < Sequel::Model(:create_quota_association_workbasket_settings)
    include ::WorkbasketHelpers::SettingsBase
    extend ActiveSupport::Concern

    def collection_models
      %w(
        QuotaAssociation
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
