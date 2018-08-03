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

      private

        def prepare_ops
          if step.in?(["configure_quota", "conditions_footnotes"])
            @ops = ops.merge(workbasket_settings.main_step_settings)
          end

          if step == "conditions_footnotes"
            @ops = ops.merge(workbasket_settings.configure_quota_step_settings)
          end
        end
    end
  end
end
