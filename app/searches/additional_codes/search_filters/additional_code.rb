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
# ::AdditionalCodes::SearchFilters::AdditionalCode.new(
#   "is", "238"
# ).sql_rules
#

module AdditionalCodes
  module SearchFilters
    class AdditionalCode
      OPERATORS_WITH_REQUIRED_PARAMS = %w(
        is
        is_not
        starts_with
      ).freeze

      attr_accessor :operator,
                    :additional_code

      def initialize(operator, additional_code = nil)
        @operator = operator
        @additional_code = additional_code.to_s
                                          .delete(" ")
                                          .upcase
      end

      def sql_rules
        return nil if required_options_are_blank?

        clause
      end

    private

      def required_options_are_blank?
        OPERATORS_WITH_REQUIRED_PARAMS.include?(operator) &&
          additional_code.blank?
      end

      def clause
        case operator
        when "is"

          [is_clause, value]
        when "is_not"

          [is_not_clause, value]
        when "starts_with"

          [starts_with_clause, value]
        end
      end

      def value
        if operator == "starts_with"
          "#{additional_code}%"
        else
          additional_code
        end
      end

      def is_clause
        <<-eos
          all_additional_codes.additional_code = ?
        eos
      end

      def is_not_clause
        <<-eos
            all_additional_codes.additional_code != ?
        eos
      end

      def starts_with_clause
        <<-eos
          all_additional_codes.additional_code ilike ?
        eos
      end

    end
  end
end
