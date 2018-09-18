#
# This filter covers 2 filters 'valid_from' and 'valid_to',
# which is date range for measure.
#
# Form parameters:
#
#   valid_from: {
#      operator: 'is',
#      value: 'selected date'  (eg: '16/04/2018')
#   },
#
#   valid_to: {
#      operator: 'is',
#      value: 'selected date'  (eg: '16/04/2018')
#   }
#
# Operator possible options:
#
# - is
# - is_not
# - is_after
# - is_before
# - is_not_specified
# - is_not_unspecified
#
# Example:
#
# ::Measures::SearchFilters::DateUniversal.new(
#   'validity_start_date', 'is_after', '16/04/2018'
# ).sql_rules
#

module Measures
  module SearchFilters
    class DateUniversal

      include ::Measures::SharedMethods::Date

      OPERATORS_WITH_REQUIRED_PARAMS = %w(
        is
        is_not
        is_after
        is_after_or_nil
        is_before
        is_before_or_nil
      )

      OPERATORS_ALLOW_NIL = %w(
        is_after_or_nil
        is_before_or_nil
      )

      attr_accessor :field_name,
                    :operator,
                    :value

      def initialize(field_name, operator, date=nil)
        @field_name = field_name
        @operator = operator
        @value = date.try(:to_date)
                     .try(:strftime, "%Y-%m-%d")
      end

      def sql_rules
        return nil if required_options_are_blank?

        clause
      end

      private

        def required_options_are_blank?
          OPERATORS_WITH_REQUIRED_PARAMS.include?(operator) &&
          value.blank?
        end

        def clause
          case operator
          when "is"
            [ is_clause, value ]
          when "is_not"
            [ is_not_clause, value ]
          when "is_before"
            [ is_before_clause, value ]
          when "is_before_or_nil"
            [ is_before_or_nil_clause, value ]
          when "is_after"
            [ is_after_clause, value ]
          when "is_after_or_nil"
            [ is_after_or_nil_clause, value ]
          when "is_not_specified"
            is_not_specified_clause
          when "is_not_unspecified"
            is_not_unspecified_clause
          end
        end

        def is_not_specified_clause
          "#{field_name} IS NULL"
        end

        def is_not_unspecified_clause
          "#{field_name} IS NOT NULL"
        end

        def is_before_clause
          compare_sql("<")
        end

        def is_after_clause
          compare_sql(">")
        end

        def compare_sql(compare_operator)
          res = "#{field_name}::date #{compare_operator} ?"
          res += " OR #{is_not_specified_clause}" if field_name == "validity_end_date" && OPERATORS_ALLOW_NIL.include?(operator)

          res
        end
    end
  end
end
