module Quotas
  module SearchFilters
    class Regulation

      attr_accessor :operator,
                    :regulation

      def initialize(operator, regulation=nil)
        @operator = operator
        @regulation = regulation.to_s.strip
      end

      def sql_rules
        return nil if regulation.blank?

        clause
      end

      private

      def clause
        case operator
          when "is"

            [ is_clause, value ]
          when "is_not"

            [ is_not_clause, value ]
          when "contains"

            [ like_clause, value ]
          when "does_not_contains"

            [ like_not_clause, value ]
        end
      end

      def value
        if operator == "contains" || operator == "does not contains"
          "%#{regulation}%"
        else
          regulation
        end
      end

      def is_not_clause
        <<-eos
            NOT EXISTS (SELECT 1 
                          FROM measures 
                         WHERE measures.ordernumber = quota_definitions.quota_order_number_id
                           AND measures.validity_start_date = quota_definitions.validity_start_date
                           AND measures.measure_generating_regulation_id = ?)
        eos
      end

      def is_clause
        <<-eos
            EXISTS (SELECT 1 
                      FROM measures 
                     WHERE measures.ordernumber = quota_definitions.quota_order_number_id
                       AND measures.validity_start_date = quota_definitions.validity_start_date
                       AND measures.measure_generating_regulation_id = ?)
        eos
      end

      def like_clause
        <<-eos
            EXISTS (SELECT 1 
                      FROM measures 
                     WHERE measures.ordernumber = quota_definitions.quota_order_number_id
                       AND measures.validity_start_date = quota_definitions.validity_start_date
                       AND measures.measure_generating_regulation_id ILIKE ?)
        eos
      end

      def like_not_clause
        <<-eos
            NOT EXISTS (SELECT 1 
                          FROM measures 
                         WHERE measures.ordernumber = quota_definitions.quota_order_number_id
                           AND measures.validity_start_date = quota_definitions.validity_start_date
                           AND measures.measure_generating_regulation_id ILIKE ?)
        eos
      end

    end
  end
end
