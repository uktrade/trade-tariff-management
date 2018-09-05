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
  end
end
