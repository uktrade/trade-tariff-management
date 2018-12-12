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
# - is_not_specified
# - is_not_unspecified
#
# Example:
#
# ::Measures::SearchFilters::CommodityCode.new(
#   "is", "3802900011"
# ).sql_rules
#

module Measures
  module SearchFilters
    class CommodityCode
      OPERATORS_WITH_REQUIRED_PARAMS = %w(
        is
        is_not
        starts_with
      ).freeze

      attr_accessor :operator,
                    :commodity_code

      def initialize(operator, commodity_code)
        @operator = operator
        @commodity_code = commodity_code
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
        when "is"

          [is_clause, value]
        when "is_not"

          [is_not_clause, value]
        when "is_not_specified"

          is_not_specified_clause
        when "is_not_unspecified"

          is_not_unspecified_clause
        when "starts_with"

          [starts_with_clause, value]
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
        "goods_nomenclature_item_id = ?"
      end

      def is_not_clause
        "goods_nomenclature_item_id IS NULL OR goods_nomenclature_item_id != ?"
      end

      def starts_with_clause
        "goods_nomenclature_item_id ilike ?"
      end

      def is_not_specified_clause
        "goods_nomenclature_item_id IS NULL"
      end

      def is_not_unspecified_clause
        "goods_nomenclature_item_id IS NOT NULL"
      end
    end
  end
end
