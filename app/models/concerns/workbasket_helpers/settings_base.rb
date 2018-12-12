module WorkbasketHelpers
  module SettingsBase
    extend ActiveSupport::Concern

    included do
      plugin :timestamps

      validates do
        presence_of :workbasket_id
      end
    end

    def workbasket
      Workbaskets::Workbasket.find(id: workbasket_id)
    end

    def collection
      collection_models.map do |db_model|
        db_model.constantize
                .by_workbasket(workbasket_id)
                .all
      end.flatten
         .sort_by(&:workbasket_sequence_number)
    end

    def collection_by_type(type_of_record)
      collection.select do |rec|
        rec.class.name == type_of_record.to_s
      end
    end

    def main_step_settings
      JSON.parse(main_step_settings_jsonb)
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

    def track_step_validations_status!(step, passed = false)
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
      @measures ||= Measure.where(measure_sid: measure_sids)
                           .order(:measure_sid)
    end

    def start_date
      settings['start_date']
    end

    def end_date
      settings['end_date']
    end

    def clean_up_temporary_data!
      collection.map(&:destroy)

      if measure_sids.present?
        self.measure_sids_jsonb = [].to_json
        self.quota_period_sids_jsonb = [].to_json if defined?(quota_period_sids_jsonb)

        save
      end
    end
  end
end
