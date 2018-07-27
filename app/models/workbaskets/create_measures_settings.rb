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

    def step_settings(step)
      public_send("#{step}_step_settings")
    end

    def set_settings_for!(step, settings_ops)
      public_send(
        "#{step}_step_settings_jsonb=",
        settings_ops.to_json
      )

      save
    end

    def track_step_validations_status!(step, passed=false)
      public_send("#{step}_step_validation_passed=", passed)
      save
    end

    def validations_passed?(step)
      public_send("#{step}_step_validation_passed").present?
    end

    def set_searchable_data_for_created_measures!
      measures.map do |measure|
        measure.manual_add = true
        measure.set_searchable_data!
      end
    end

    def measure_sids
      JSON.parse(measure_sids_jsonb).uniq
    end

    def measures
      Measure.where(measure_sid: measure_sids)
             .order(:measure_sid)
    end

    def start_date
      settings['start_date']
    end

    def end_date
      settings['end_date']
    end
  end
end
