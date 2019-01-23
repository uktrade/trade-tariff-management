module Quotas
  module SearchFilters
    class OrderNumber
      attr_accessor :operator,
                    :order_number

      def initialize(operator, order_number = nil)
        @operator = operator
        @order_number = order_number.to_s.strip
      end

      def sql_rules
        return nil if order_number.blank?

        clause
      end

    private

      def clause
        case operator
        when "is"

          [is_clause, value]
        when "starts_with"

          [like_clause, value]
        when "contains"

          [like_clause, value]
        end
      end

      def value
        if operator == "starts_with"
          "#{order_number}%"
        elsif operator == "contains"
          "%#{order_number}%"
        else
          order_number
        end
      end

      def is_clause
        <<-eos
            quota_definitions.quota_order_number_id = ?
        eos
      end

      def like_clause
        <<-eos
            quota_definitions.quota_order_number_id ilike ?
        eos
      end
    end
  end
end
