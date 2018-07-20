module Workbaskets
  class CreateMeasuresSettings < Sequel::Model(:create_measures_workbasket_settings)

    plugin :timestamps

    validates do
      presence_of :workbasket_id
    end

    def workbasket
      Workbaskets::Workbasket.find(id: workbasket_id)
    end

    def measure_sids
      JSON.parse(measure_sids_jsonb)
    end

    def measures
      Measure.where(measure_sid: measure_sids)
             .order(:measure_sid)
    end

    def settings
      main_step_settings.merge(duties_conditions_footnotes_step_settings)
    end

    def main_step_settings
      JSON.parse(main_step_settings_jsonb)
    end

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
  end
end
