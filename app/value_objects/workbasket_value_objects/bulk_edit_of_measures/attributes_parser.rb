module WorkbasketValueObjects
  module BulkEditOfMeasures
    class AttributesParser < WorkbasketValueObjects::AttributesParserBase
      SIMPLE_OPS = %w(
        start_date
        end_date
        operation_date
        workbasket_name
        commodity_codes
        additional_codes
      ).freeze

      SIMPLE_OPS.map do |option_name|
        define_method(option_name) do
          ops[option_name]
        end
      end

      def created_by
        User.find(id: workbasket_settings.workbasket.user_id).name
      end

      def reason_for_edit
        JSON.parse(workbasket_settings.values[:main_step_settings_jsonb])['reason']
      end

    private

      def prepare_ops
        if step == "duties_conditions_footnotes"
          @ops = ops.merge(workbasket_settings.main_step_settings)
        end
      end
    end
  end
end
