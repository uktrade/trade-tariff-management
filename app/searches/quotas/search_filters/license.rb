module Quotas
  module SearchFilters
    class License
      attr_accessor :operator,
                    :license

      def initialize(operator, license = nil)
        @operator = operator
        @license = license.to_s.strip
      end

      def sql_rules
        return nil if license.blank? && operator == 'yes'

        clause
      end

    private

      def clause
        case operator
        when "yes"

          [yes_clause, license]
        when "no"

          no_clause
        end
      end

      def yes_clause
        <<~eos
          EXISTS ( SELECT 1
                     FROM measures,
                          measure_conditions
                    WHERE measures.ordernumber = quota_definitions.quota_order_number_id
                      AND measures.validity_start_date = quota_definitions.validity_start_date
                      AND measure_conditions.measure_sid = measures.measure_sid
                      AND measure_conditions.certificate_code = ?)
        eos
      end

      def no_clause
        <<~eos
          NOT EXISTS ( SELECT 1
                         FROM measures,
                              measure_conditions
                        WHERE measures.ordernumber = quota_definitions.quota_order_number_id
                          AND measures.validity_start_date = quota_definitions.validity_start_date
                          AND measure_conditions.measure_sid = measures.measure_sid
                          AND NOT measure_conditions.certificate_code IS NULL)
        eos
      end
    end
  end
end
