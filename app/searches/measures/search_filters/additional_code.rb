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
                    :full_code,
                    :additional_code,
                    :additional_code_type_id

      def initialize(operator, additional_code=nil)
        @operator = operator
        @full_code = additional_code.to_s
                                    .delete(" ")
                                    .downcase

        if full_code.present?
          if search_with_type_letter_prefix?
            @additional_code_type_id = full_code[0]
            @additional_code = full_code[1..-1]
          else
            @additional_code = full_code
          end
        end
      end

      def sql_rules
        return nil if full_code.blank?

        if search_with_type_letter_prefix?
          [ clause, additional_code_type_id, value ]
        else
          [ clause, value ]
        end
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
          if search_with_type_letter_prefix?
            "lower(additional_code_type_id) = ? AND additional_code_id = ?"
          else
            "additional_code_id = ?"
          end
        end

        def is_not_clause
          if search_with_type_letter_prefix?
            <<-eos
              additional_code_id IS NULL OR
              ( lower(additional_code_type_id) != ? OR additional_code_id != ? )
            eos
          else
            "additional_code_id IS NULL OR additional_code_id != ?"
          end
        end

        def starts_with_clause
          if search_with_type_letter_prefix?
            "lower(additional_code_type_id) = ? AND additional_code_id ilike ?"
          else
            "additional_code_id ilike ?"
          end
        end

        def search_with_type_letter_prefix?
          !(full_code[0].to_s =~  /\A[-+]?[0-9]*\.?[0-9]+\Z/)
        end
    end
  end
end
