module Quotas
  module SearchFilters
    class CommodityCode

      OPERATORS_WITH_REQUIRED_PARAMS = %w(
        includes
        is
        is_not
        starts_with
      )

      attr_accessor :operator,
                    :commodity_code

      def initialize(operator, commodity_code=nil)
        @operator = operator
        @commodity_code = commodity_code.to_s
                                        .delete(" ")
                                        .downcase
      end

      def sql_rules
        return nil if required_options_are_blank?

        clause
      end

      private

      def required_options_are_blank?
        OPERATORS_WITH_REQUIRED_PARAMS.include?(operator) &&
            commodity_code.blank?
      end

      def clause
        case operator
        when "includes"

          [ includes_clause, '0(\?=0*$)', value ]
        when "is"

          [ is_clause, value ]
        when "is_not"

          [ is_not_clause, value ]
        when "are_not_specified"

          specified_not_clause
        when "are_not_unspecified"

          specified_clause
        when "starts_with"

          [ starts_with_clause, value ]
        end
      end

      def value
        if operator == "starts_with"
          "#{commodity_code}%"
        else
          commodity_code
        end
      end

      def includes_clause
        <<-eos
EXISTS (SELECT 1 
          FROM measures 
         WHERE measures.ordernumber = quota_definitions.quota_order_number_id
           AND measures.validity_start_date = quota_definitions.validity_start_date
           AND regexp_replace(measures.goods_nomenclature_item_id, ?, '_', 'g') LIKE ?)
        eos
      end

      def is_clause
        <<-eos
EXISTS (SELECT 1 
          FROM measures 
         WHERE measures.ordernumber = quota_definitions.quota_order_number_id
           AND measures.validity_start_date = quota_definitions.validity_start_date
           AND measures.goods_nomenclature_item_id = ?)
        eos
      end

      def is_not_clause
        <<-eos
(
EXISTS (SELECT 1 
          FROM measures 
         WHERE measures.ordernumber = quota_definitions.quota_order_number_id
           AND measures.validity_start_date = quota_definitions.validity_start_date)
AND
NOT EXISTS (SELECT 1 
              FROM measures 
             WHERE measures.ordernumber = quota_definitions.quota_order_number_id
               AND measures.validity_start_date = quota_definitions.validity_start_date
               AND measures.goods_nomenclature_item_id = ?)
)
        eos
      end

      def specified_not_clause
        <<-eos
NOT EXISTS (SELECT 1 
              FROM measures 
             WHERE measures.ordernumber = quota_definitions.quota_order_number_id
           AND measures.validity_start_date = quota_definitions.validity_start_date)
        eos
      end

      def specified_clause
        <<-eos
EXISTS (SELECT 1 
          FROM measures 
         WHERE measures.ordernumber = quota_definitions.quota_order_number_id
           AND measures.validity_start_date = quota_definitions.validity_start_date)
        eos
      end

      def starts_with_clause
        <<-eos
EXISTS (SELECT 1 
          FROM measures 
         WHERE measures.ordernumber = quota_definitions.quota_order_number_id
           AND measures.validity_start_date = quota_definitions.validity_start_date
           AND measures.goods_nomenclature_item_id ILIKE ?)
        eos
      end
    end
  end
end
