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
# Example:
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

      def initialize(operator, additional_code=nil)
        @operator = operator
        @additional_code = additional_code.to_s
                                          .delete(" ")
                                          .downcase
      end

      def sql_rules
        return nil if additional_code.blank?

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
          <<-eos
            searchable_data #>> '{"additional_code"}' = ?
          eos
        end

        def is_not_clause
          <<-eos
            searchable_data #>> '{"additional_code"}' IS NULL OR
            searchable_data #>> '{"additional_code"}' != ?
          eos
        end

        def starts_with_clause
          <<-eos
            searchable_data #>> '{"additional_code"}' ilike ?
          eos
        end
    end
  end
end
