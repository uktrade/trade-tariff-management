module Workbaskets
  class BulkEditOfMeasuresSettings < Sequel::Model(:bulk_edit_of_measures_settings)
    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
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
      JSON.parse(main_step_settings_jsonb)
    end

    def set_workbasket_system_data!
      workbasket.update(
        title: main_step_settings['title'],
        operation_date: main_step_settings['start_date'].try(:to_date)
      )
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

    def workbasket_items
      @workbasket_items ||= workbasket.items
    end

    def commodity_codes_covered
      @commodity_codes_covered ||= workbasket_items.select do |i|
        i.hash_data["goods_nomenclature"].present? &&
          i.hash_data["goods_nomenclature"]["goods_nomenclature_item_id"].present?
      end.map do |i|
        i.hash_data["goods_nomenclature"]["goods_nomenclature_item_id"]
      end.uniq
    end

    def additional_codes_covered
      @additional_codes_covered ||= workbasket_items.select do |i|
        i.hash_data["additional_code"].present? &&
          i.hash_data["additional_code"]["additional_code"].present?
      end.map do |i|
        i.hash_data["additional_code"]["additional_code"]
      end.uniq
    end
  end
end
