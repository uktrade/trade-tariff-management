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
# ::Measures::SearchFilters::MeasureSid.new(
#   "is", "3632261"
# ).sql_rules
#

module Measures
  module SearchFilters
    class MeasureSid
      attr_accessor :operator,
                    :measure_sid

      def initialize(operator, measure_sid)
        @operator = operator
        @measure_sid = measure_sid.to_s.strip
      end

      def sql_rules
        return nil if measure_sid.blank?

        case operator
        when "is"

          [is_clause, measure_sids]
        when "starts_with", "contains"

          [equal_clause, equal_value]
        end
      end

    private

      def is_clause
        <<-eos
          measure_sid::text in ?
        eos
      end

      def equal_clause
        <<-eos
          measure_sid::text ilike ?
        eos
      end

      def measure_sids
        measure_sid.split(',').map(&:strip)
      end

      def equal_value
        case operator
        when "starts_with"
          "#{measure_sid}%"
        when "contains"
          "%#{measure_sid}%"
        end
      end
    end
  end
end
