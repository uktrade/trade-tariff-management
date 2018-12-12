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
# - starts_with
# - contains
#
# Example:
#
# ::Measures::SearchFilters::GroupName.new(
#   "is", "Test group"
# ).sql_rules
#

module Measures
  module SearchFilters
    class GroupName
      attr_accessor :operator,
                    :group_name

      def initialize(operator, group_name)
        @operator = operator
        @group_name = group_name
      end

      def sql_rules
        return nil if group_name.blank?

        case operator
        when "is"

          [is_clause, group_name]
        when "starts_with", "contains"

          [equal_clause, equal_value]
        end
      end

    private

      def is_clause
        <<-eos
          searchable_data #>> '{"workbasket_name"}' = ?
        eos
      end

      def equal_clause
        <<-eos
          searchable_data #>> '{"workbasket_name"}' ilike ?
        eos
      end

      def equal_value
        case operator
        when "starts_with"
          "#{group_name}%"
        when "contains"
          "%#{group_name}%"
        end
      end
    end
  end
end
