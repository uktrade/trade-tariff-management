module Workbaskets
  class CreateMeasuresSettings < Sequel::Model(:create_measures_workbasket_settings)

    plugin :timestamps

    validates do
      presence_of :workbasket_id
    end

    def workbasket
      Workbaskets::Workbasket.find(id: workbasket_id)
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

    def step_settings(current_step)
      public_send("#{current_step}_step_settings")
    end

    def set_settings_for!(current_step, settings_ops)
      public_send(
        "#{current_step}_step_settings_jsonb=",
        settings_ops.to_json
      )

      save
    end

    def track_step_validations_status!(current_step, passed=false)
      public_send("#{current_step}_step_validation_passed=", passed)
      save
    end

    def validations_passed?(step)
      public_send("#{step}_step_validation_passed?")
    end
  end
end
