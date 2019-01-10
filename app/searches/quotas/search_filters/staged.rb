module Quotas
  module SearchFilters
    class Staged
      attr_accessor :operator

      def initialize(operator, _dummy = nil)
        @operator = operator
      end

      def sql_rules
        clause
      end

    private

      def clause
        case operator
        when "yes"

          yes_clause
        when "no"

          no_clause
        end
      end

      def yes_clause
        <<~eos
          quota_definitions.quota_order_number_id IN (
            WITH quota AS (
              SELECT quota.quota_order_number_id,
                     EXTRACT(YEAR FROM quota.validity_start_date) validity_year,
                     SUM(quota.initial_volume) initial_volume
                FROM quota_definitions quota
               GROUP BY quota.quota_order_number_id, EXTRACT(YEAR FROM quota.validity_start_date)
          )
            SELECT quota1.quota_order_number_id
              FROM quota quota1,
                   quota quota2
             WHERE quota1.quota_order_number_id = quota2.quota_order_number_id
               AND quota1.validity_year = quota2.validity_year - 1
               AND quota1.initial_volume != quota2.initial_volume
          )
        eos
      end

      def no_clause
        <<~eos
          NOT #{yes_clause}
        eos
      end
    end
  end
end
