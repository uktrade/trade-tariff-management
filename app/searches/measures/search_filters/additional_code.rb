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
# ::Measures::SearchFilters::AdditionalCode.new(
#   "is", "238"
# ).sql_rules
#

module Measures
  module SearchFilters
    class AdditionalCode

      attr_accessor :operator,
                    :additional_code

      def initialize(operator, additional_code)
        @operator = operator
        @additional_code = additional_code
      end

      def sql_rules
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
            "#{additional_code}%"
          else
            additional_code
          end
        end

        def is_clause
          "additional_code_id = ?"
        end

        def is_not_clause
          "additional_code_id IS NULL OR additional_code_id != ?"
        end

        def starts_with_clause
          "additional_code_id ilike ?"
        end
    end
  end
end
