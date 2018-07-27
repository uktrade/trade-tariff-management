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
      COLLECTION_MODELS.map do |db_model|
        db_model.constantize
                .by_workbasket(workbasket_id)
                .all
      end.flatten
         .sort do |a, b|
         a.workbasket_sequence_number <=> b.workbasket_sequence_number
      end
    end

    def settings
      main_step_settings.merge(duties_conditions_footnotes_step_settings)
    end

    def main_step_settings
      JSON.parse(main_step_settings_jsonb)
    end
  end
end
