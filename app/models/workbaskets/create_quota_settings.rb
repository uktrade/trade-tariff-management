module Workbaskets
  class CreateQuotaSettings < Sequel::Model(:create_quota_workbasket_settings)
    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
        QuotaAssociation
        QuotaOrderNumber
        QuotaOrderNumberOrigin
        QuotaOrderNumberOriginExclusion
        QuotaDefinition
        Measure
        Footnote
        FootnoteDescription
        FootnoteDescriptionPeriod
        FootnoteAssociationMeasure
        MeasureComponent
        MeasureCondition
        MeasureConditionComponent
        MeasureExcludedGeographicalArea
      )
    end

    def settings
      main_step_settings.merge(configure_quota_step_settings)
                        .merge(conditions_footnotes_step_settings)
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

    def parent_quota_period_sids
      JSON.parse(parent_quota_period_sids_jsonb).uniq
    end

    def quota_periods
      @quota_periods ||= QuotaDefinition.where(quota_definition_sid: quota_period_sids)
                                        .order(:quota_definition_sid)
                                        .all
    end

    def parent_quota_periods
      @parent_quota_periods ||= QuotaDefinition.where(quota_definition_sid: parent_quota_period_sids)
                                    .order(:quota_definition_sid)
                                    .all
    end

    def quota_periods_by_type(type_of_quota)
      quota_periods.select do |quota_period|
        quota_period.workbasket_type_of_quota == type_of_quota
      end
    end

    def ordered_quota_periods
      quota_periods.sort_by(&:validity_start_date)
    end

    def earliest_period_date
      ordered_quota_periods.first
                           .validity_start_date
    end

    def latest_period_date
      ordered_quota_periods.last
                           .validity_start_date
    end

    def period_in_years
      diff = (latest_period_date.year - earliest_period_date.year)
      [1, diff].max
    end

    def reset_step_validations
      super([:configure_quota, :conditions_footnotes])
    end
  end
end
