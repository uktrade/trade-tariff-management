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
# Example:
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

      def initialize(operator, regulation_id = nil)
        @operator = operator
        @regulation_id = regulation_id
      end

      def sql_rules
        return nil if regulation_id.blank?

        [
          query_rule, value, value, value
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
        <<-eos
            measure_generating_regulation_id = ? OR
            searchable_data #>> '{"regulation_code"}' = ? OR
            justification_regulation_id = ?
        eos
      end

      def is_not_clause
        <<-eos
            measure_generating_regulation_id != ? AND
            searchable_data #>> '{"regulation_code"}' != ? AND
            (justification_regulation_id != ? OR justification_regulation_id IS NULL)
        eos
      end

      def contains_clause
        <<-eos
            measure_generating_regulation_id ilike ? OR
            searchable_data #>> '{"regulation_code"}' ilike ? OR
            justification_regulation_id ilike ?
        eos
      end

      def does_not_contain_clause
        <<-eos
            measure_generating_regulation_id NOT ilike ? AND
            searchable_data #>> '{"regulation_code"}' NOT ilike ? AND
            justification_regulation_id NOT ilike ?
        eos
      end
    end
  end
end
