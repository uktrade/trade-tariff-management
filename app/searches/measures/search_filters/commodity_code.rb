#
# Form parameters:
#
# {
#   operator: 'is',
#   value: 'user input'
# }
#
# Operator possible options:
#
# - is
# - is_not
# - starts_with
#
# Exxample:
#
# ::Measures::SearchFilters::CommodityCode.new(
#   "is", "238"
# ).sql_rules
#

module Measures
  module SearchFilters
    class CommodityCode

      attr_accessor :operator,
                    :commodity_code

      def initialize(operator, commodity_code)
        @operator = operator
        @commodity_code = commodity_code
      end


        value = commodity_code

        case operator
        when "is"

          q_rule = "goods_nomenclature_item_id = ?"
        when "is_not"

          q_rule = "goods_nomenclature_item_id IS NULL OR goods_nomenclature_item_id != ?"
        when "is_not_specified"

          q_rule = "goods_nomenclature_item_id IS NULL"
          value = nil
        when "is_not_unspecified"

          q_rule = "goods_nomenclature_item_id IS NOT NULL"
          value = nil
        when "starts_with"

          q_rule = "goods_nomenclature_item_id ilike ?"
          value = "#{commodity_code}%"
        end

         value.present? ? where(q_rule, value) : where(q_rule)


      def sql_rules
        return nil if commodity_code.blank?

        [ clause, value ]
      end

      private

        def clause
          case operator
          when "is"

            is_clause
          when "is_not"

            is_not_clause
          when "starts_with"

            starts_with_clause
          end
        end

        def value
          if operator == "starts_with"
            "#{commodity_code}%"
          else
            commodity_code
          end
        end

        def is_clause
          "commodity_code_id = ?"
        end

        def is_not_clause
          "commodity_code_id IS NULL OR commodity_code_id != ?"
        end

        def starts_with_clause
          "commodity_code_id ilike ?"
        end
    end
  end
end
