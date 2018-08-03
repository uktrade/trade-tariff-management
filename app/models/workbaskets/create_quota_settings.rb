module Workbaskets
  class CreateQuotaSettings < Sequel::Model(:create_quota_workbasket_settings)

    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
        QuotaOrderNumber
        QuotaOrderNumberOrigin
        QuotaOrderNumberOriginExclusion
        QuotaDefinition
        Measure
        Footnote
        FootnoteDescription
        FootnoteDescriptionPeriod
        FootnoteAssociationMeasure
        MeasureCondition
        MeasureConditionComponent
        MeasureExcludedGeographicalArea
      )
    end

    def configure_quota_step_settings
      JSON.parse(configure_quota_step_settings_jsonb)
    end

    def conditions_footnotes_step_settings
      JSON.parse(conditions_footnotes_step_settings_jsonb)
    end

    def quota_period_sids
      JSON.parse(quota_period_sids_jsonb).uniq
    end

    def quota_periods
      QuotaDefinition.where(quota_definition_sid: quota_period_sids)
                     .order(:quota_definition_sid)
    end
  end
end
