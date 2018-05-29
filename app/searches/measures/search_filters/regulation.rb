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
# - contains
# - does_not_contain
#
# Exxample:
#
# ::Measures::SearchFilters::Regulation.new(
#   "is", "R2131244"
# ).sql_rules
#

module Measures
  module SearchFilters
    class Regulation

      attr_accessor :operator,
                    :regulation_id

      def initialize(operator, regulation_id)
        @operator = operator
        @regulation_id = regulation_id
      end

      def sql_rules
        [
          query_rule, value, value
        ]
      end

      private

        def query_rule
          case operator
          when "is"

            is_clause
          when "is_not"

            is_not_clause
          when "contains"

            contains_clause
          when "does_not_contain"

            does_not_contain_clause
          end
        end

        def value
          if %w(contains does_not_contain).include?(operator)
            "%#{regulation_id}%"
          else
            regulation_id
          end
        end

        def is_clause
          "measure_generating_regulation_id = ? OR justification_regulation_id = ?"
        end

        def is_not_clause
          "measure_generating_regulation_id != ? AND justification_regulation_id != ?"
        end

        def contains_clause
          "measure_generating_regulation_id ilike ? OR justification_regulation_id ilike ?"
        end

        def does_not_contain_clause
          "measure_generating_regulation_id NOT ilike ? AND justification_regulation_id NOT ilike ?"
        end
    end
  end
end
