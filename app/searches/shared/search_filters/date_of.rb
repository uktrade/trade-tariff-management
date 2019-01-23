#
# Form parameters:
#
# {
#   operator: 'is',
#   mode: 'creation' (or 'authoring' / 'last_status_change')
#   value: 'selected date'  (eg: '16/04/2018')
# }
#
# Search mode:
#
# - creation
# - authoring
# - last_status_change
#
# Operator possible options:
#
# - is
# - is_not
# - is_after
# - is_before
#
# Example:
#
# ::Measures::SearchFilters::DateOf.new(
#   operator: 'is',
#   mode: 'creation',
#   value: '16/04/2018'
# ).sql_rules
#

module Shared
  module SearchFilters
    class DateOf
      include ::Shared::Methods::Date

      attr_accessor :operator,
                    :mode,
                    :value

      def initialize(ops = {})
        @operator = ops[:operator]
        @mode = ops[:mode]
        @value = ops[:value].try(:to_date)
                            .try(:strftime, "%Y-%m-%d")
      end

      def sql_rules
        return nil if required_params_are_blank?

        [clause, value]
      end

    private

      def required_params_are_blank?
        operator.blank? ||
          mode.blank? ||
          value.blank?
      end

      def clause
        case operator
        when "is"

          is_clause
        when "is_not"

          is_not_clause
        when "is_before"

          is_before_clause
        when "is_after"

          is_after_clause
        end
      end

      def field_name
        case mode
        when "creation", "authoring"
          "added_at"
        when "last_status_change"
          "last_status_change_at"
        end
      end
    end
  end
end
