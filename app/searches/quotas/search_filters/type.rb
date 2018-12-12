module Quotas
  module SearchFilters
    class Type
      attr_accessor :operator,
                    :measure_type_id

      def initialize(operator, measure_type_id = nil)
        @operator = operator
        @measure_type_id = measure_type_id.to_s.strip
      end

      def sql_rules
        return nil if measure_type_id.blank?

        clause
      end

    private

      def clause
        case operator
        when "is"

          [is_clause, measure_type_id]
        when "is_not"

          [is_not, measure_type_id]
        end
      end

      def is_clause
        <<-eos
            EXISTS (SELECT 1
                      FROM measures
                     WHERE measures.ordernumber = quota_definitions.quota_order_number_id
                       AND measures.validity_start_date = quota_definitions.validity_start_date
                       AND measures.measure_type_id = ?)
        eos
      end

      def is_not
        <<-eos
            NOT EXISTS (SELECT 1
                          FROM measures
                         WHERE measures.ordernumber = quota_definitions.quota_order_number_id
                           AND measures.validity_start_date = quota_definitions.validity_start_date
                           AND measures.measure_type_id = ?)
        eos
      end
    end
  end
end
