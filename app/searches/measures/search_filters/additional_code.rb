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
# ::Measures::SearchFilters::AdditionalCode.new(
#   "is", "238"
# ).sql_rules
#

module Measures
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
                                          .downcase
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
          "#{additional_code}%"
        else
          additional_code
        end
      end

      def is_clause
        <<-eos
          searchable_data #>> '{"additional_code"}' = ?
        eos
      end

      def is_not_clause
        <<-eos
            #{is_not_specified_clause} OR
            searchable_data #>> '{"additional_code"}' != ?
        eos
      end

      def starts_with_clause
        <<-eos
          searchable_data #>> '{"additional_code"}' ilike ?
        eos
      end

      def is_not_specified_clause
        <<-eos
          searchable_data #>> '{"additional_code"}' IS NULL
        eos
      end

      def is_not_unspecified_clause
        <<-eos
          searchable_data #>> '{"additional_code"}' IS NOT NULL
        eos
      end
    end
  end
end
