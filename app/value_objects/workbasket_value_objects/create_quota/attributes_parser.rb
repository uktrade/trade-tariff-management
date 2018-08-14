module WorkbasketValueObjects
  module CreateQuota
    class AttributesParser < WorkbasketValueObjects::AttributesParserBase

      SIMPLE_OPS = %w(
        start_date
        end_date
        operation_date
        workbasket_name
        quota_ordernumber
        commodity_codes
        additional_codes
        quota_is_licensed
      )

      SIMPLE_OPS.map do |option_name|
        define_method(option_name) do
          ops[option_name]
        end
      end

      def quota_periods
        if ops[:quota_periods].present?
          ops[:quota_periods].select do |k, option|
            option['start_date'].present? &&
            option['period'].present? &&
            option['period'].to_s != "1_repeating" &&
            option['measurement_unit_code'].present? && (
              option["opening_balances"].any? do |k, opening_balance_ops|
                balance_source = option["staged"] == "true" ? opening_balance_ops : option
                balance = balance_source["balance"]
                balance.present?
              end
            )
          end
        else
          []
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
