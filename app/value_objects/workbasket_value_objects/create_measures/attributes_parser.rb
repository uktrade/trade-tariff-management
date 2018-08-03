module WorkbasketValueObjects
  module CreateMeasures
    class AttributesParser < WorkbasketValueObjects::AttributesParserBase

      SIMPLE_OPS = %w(
        start_date
        end_date
        operation_date
        workbasket_name
        commodity_codes
        additional_codes
      )

      SIMPLE_OPS.map do |option_name|
        define_method(option_name) do
          ops[option_name]
        end
      end

      def measure_components
        prepare_collection(:measure_components, :duty_expression_id)
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
