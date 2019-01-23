module Quotas
  module SearchFilters
    class Origin < ::Shared::SearchFilters::CollectionFilterBase
      attr_accessor :operator,
                    :origin

      def initialize(operator, origin = nil)
        @operator = operator
        @origin = origin.to_s.strip
      end

      def sql_rules
        return nil if origin.blank?

        clause
      end

    private

      def clause
        case operator
        when "is"

          [is_clause, origin]
        when "is_not"

          [is_not_clause, origin]
        end
      end

      def is_clause
        <<~eos
          EXISTS (SELECT 1
                    FROM quota_order_numbers,
                         quota_order_number_origins
                   WHERE quota_order_numbers.quota_order_number_id = quota_definitions.quota_order_number_id
                     AND quota_order_number_origins.quota_order_number_sid = quota_order_numbers.quota_order_number_sid
                     AND quota_order_number_origins.geographical_area_id = ?)
        eos
      end

      def is_not_clause
        <<~eos
          (
          NOT EXISTS (SELECT 1
                        FROM quota_order_numbers,
                             quota_order_number_origins
                       WHERE quota_order_numbers.quota_order_number_id = quota_definitions.quota_order_number_id
                         AND quota_order_number_origins.quota_order_number_sid = quota_order_numbers.quota_order_number_sid
                         AND quota_order_number_origins.geographical_area_id = ?)
        eos
      end
    end
  end
end
