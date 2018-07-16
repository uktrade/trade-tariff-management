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
      JSON.parse(settings_jsonb)
    end

    def step_settings(current_step)
      settings.select do |k, v|
        Workbaskets::CreateMeasures::SettingsSaver.keys_for_step(current_step)
                                                  .include?(k)
      end
    end
  end
end
