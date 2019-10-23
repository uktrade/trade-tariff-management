module Workbaskets
  class DeleteQuotaAssociationSettings < Sequel::Model(:delete_quota_association_workbasket_settings)
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
      DeleteQuotaAssociationSettingsDecorator.decorate(self)
    end
  end
end
