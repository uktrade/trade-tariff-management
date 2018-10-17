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

    def quota_settings
      JSON.parse(quota_settings_jsonb)
    end

    def set_workbasket_system_data!
      workbasket.update(
          title: main_step_settings['title'],
          operation_date: main_step_settings['start_date'].try(:to_date)
      )
    end

    def workbasket_action
      main_step_settings['workbasket_action'] if main_step_settings.present?
    end

    def editable_workbasket?
      workbasket_action.in?(%w(edit_quota edit_quota_measures))
    end

    def quota_definition
      QuotaDefinition.find(quota_definition_sid: quota_sid)
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
        i.record_id.to_s == target_id
      end
    end

  end
end