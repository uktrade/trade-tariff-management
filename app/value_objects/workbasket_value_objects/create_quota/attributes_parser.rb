module WorkbasketValueObjects
  module CreateQuota
    class AttributesParser < WorkbasketValueObjects::AttributesParserBase
      SIMPLE_OPS = %w(
        start_date
        end_date
        operation_date
        workbasket_name
        quota_ordernumber
        quota_precision
        commodity_codes
        additional_codes
        quota_is_licensed
        sub_quotas
      ).freeze

      SIMPLE_OPS.map do |option_name|
        define_method(option_name) do
          ops[option_name]
        end
      end

      def quota_periods
        if ops[:quota_periods].present?
          ops[:quota_periods].select do |_k, section_ops|
            general_requirements_passed?(section_ops) &&
              quota_type_specific_requirements_passed?(section_ops, section_ops['type'])
          end
        else
          []
        end
      end

      def formatted_commodity_codes(commodity_codes)
        if commodity_codes.present?
          commodity_codes.split(/[\s|,]+/)
              .map(&:strip)
              .reject(&:blank?)
              .uniq.join(', ')
        end
      end

    private

      def prepare_ops
        if step.in?(%w[configure_quota conditions_footnotes])
          @ops = ops.merge(workbasket_settings.main_step_settings)
        end

        if step == "conditions_footnotes"
          @ops = ops.merge(workbasket_settings.configure_quota_step_settings)
        end
      end

      def general_requirements_passed?(section_ops)
        return true if section_ops['type'] == 'custom'

        section_ops['start_date'].present? &&
          section_ops['period'].present? &&
          section_ops['period'].to_s != "1_repeating" &&
          section_ops['measurement_unit_code'].present?
      end

      def quota_type_specific_requirements_passed?(section_ops, period_type)
        case period_type
        when "annual"

          section_ops["opening_balances"].all? do |_k, opening_balance_ops|
            balance_source = section_ops["staged"] == "true" ? opening_balance_ops : section_ops
            balance = balance_source["balance"]
            balance.present?
          end

        when "bi_annual", "quarterly", "monthly"

          section_ops["opening_balances"].all? do |_k, opening_balance_ops|
            opening_balance_ops.all? do |target_key, balance_part_ops|
              balance = if section_ops["staged"] == "true"
                          balance_part_ops['balance']
                        else
                          section_ops['balance'][target_key]
              end

              balance.present?
            end
          end

        when "custom"

          section_ops["periods"].present? &&
            !section_ops["periods"].empty? &&
            section_ops["periods"].all? do |_k, opening_balance_ops|
              opening_balance_ops["start_date"].present? &&
                opening_balance_ops["end_date"].present? &&
                opening_balance_ops["balance"].present? &&
                opening_balance_ops['measurement_unit_code'].present?
            end

        end
      end
    end
  end
end
