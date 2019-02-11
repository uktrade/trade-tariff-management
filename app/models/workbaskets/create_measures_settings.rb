module Workbaskets
  class CreateMeasuresSettings < Sequel::Model(:create_measures_workbasket_settings)
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
      main_step_settings.merge(duties_conditions_footnotes_step_settings)
    end

    def duties_conditions_footnotes_step_settings
      JSON.parse(duties_conditions_footnotes_step_settings_jsonb)
    end

    def commodity_codes_covered
      @commodity_codes_covered ||= measures.pluck(:goods_nomenclature_item_id)
                                           .uniq
    end

    def additional_codes_covered
      @additional_codes_covered ||= measures.where("additional_code_id IS NOT NULL AND additional_code_type_id IS NOT NULL")
                                            .pluck(:additional_code_type_id, :additional_code_id).map(&:join).uniq
    end

    def reset_step_validations
      super([:duties_conditions_footnotes])
    end
  end
end
