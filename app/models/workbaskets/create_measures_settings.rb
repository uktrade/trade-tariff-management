module Workbaskets
  class CreateMeasuresSettings < Sequel::Model(:create_measures_workbasket_settings)

    include ::WorkbasketHelpers::SettingsBase

    COLLECTION_MODELS = %w(
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

    def duties_conditions_footnotes_step_settings
      JSON.parse(duties_conditions_footnotes_step_settings_jsonb)
    end

    def start_date
      settings['start_date']
    end

    def end_date
      settings['end_date']
    end
  end
end
