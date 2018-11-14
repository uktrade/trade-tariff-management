module Workbaskets
  class BulkEditOfQuotasSettings < Sequel::Model(:bulk_edit_of_quotas_settings)

    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
        QuotaAssociation
        QuotaOrderNumber
        QuotaOrderNumberOrigin
        QuotaOrderNumberOriginExclusion
        QuotaDefinition
        QuotaSuspensionPeriod
        QuotaUnsuspensionEvent
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

    def configure_step_settings
      JSON.parse(configure_step_settings_jsonb)
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
      quota_periods.sort do |a, b|
        a.validity_start_date <=> b.validity_start_date
      end
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

    def set_workbasket_system_data!
      workbasket.update(
          title: configure_step_settings['title'],
          operation_date: configure_step_settings['start_date'].try(:to_date)
      )
    end

    def workbasket_action
      configure_step_settings['workbasket_action'] if configure_step_settings.present?
    end

    def editable_workbasket?
      workbasket_action.in?(%w(edit_quota edit_quota_measures))
    end

    def edit_quota_workbasket?
      workbasket_action == 'edit_quota'
    end

    def quota_definition
      @quota_definition ||= QuotaDefinition.find(quota_definition_sid: initial_quota_sid)
    end

    def quota_definition_suspended?(date = Date.today)
      quota_definition.last_suspension_period.present? &&
        (quota_definition.last_suspension_period.suspension_end_date.blank? ||
          quota_definition.last_suspension_period.suspension_end_date < date)
    end

    def track_current_page_loaded!(current_page)
      res = JSON.parse(batches_loaded)
      res[current_page] = true

      self.batches_loaded = res.to_json
    end

    def batches_loaded_pages
      JSON.parse(batches_loaded)
    end

    def get_item_by_id(target_id)
      workbasket.items.detect do |i|
        target_id.in?([i.record_id.to_s, i.row_id])
      end || ::Workbaskets::Item.new_from_empty_record(
          workbasket, Measure.new, target_id
      )
    end

  end
end