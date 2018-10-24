module Quotas
  module SearchFilters
    class AdditionalCode

      OPERATORS_WITH_REQUIRED_PARAMS = %w(
        is
        is_not
        starts_with
      )

      attr_accessor :operator,
                    :additional_code

      def initialize(operator, additional_code=nil)
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

            [ is_clause, value ]
          when "is_not"

            [ is_not_clause, value ]
          when "is_not_specified"

            specified_not_clause
          when "is_not_unspecified"

            specified_clause
          when "starts_with"

            [ starts_with_clause, value ]
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
EXISTS (SELECT 1 
          FROM measures 
         WHERE measures.ordernumber = quota_definitions.quota_order_number_id
           AND measures.validity_start_date = quota_definitions.validity_start_date
           AND measures.additional_code_id = ?)
          eos
        end

        def is_not_clause
          <<-eos
NOT EXISTS (SELECT 1 
              FROM measures 
             WHERE measures.ordernumber = quota_definitions.quota_order_number_id
               AND measures.validity_start_date = quota_definitions.validity_start_date
               AND measures.additional_code_id = ?)
          eos
        end

        def specified_not_clause
          <<-eos
NOT #{specified_clause}
          eos
        end

        def specified_clause
          <<-eos
EXISTS (SELECT 1 
          FROM measures 
         WHERE measures.ordernumber = quota_definitions.quota_order_number_id
           AND measures.validity_start_date = quota_definitions.validity_start_date
           AND NOT measures.additional_code_id IS NULL)
          eos
        end

        def starts_with_clause
          <<-eos
EXISTS (SELECT 1 
          FROM measures 
         WHERE measures.ordernumber = quota_definitions.quota_order_number_id
           AND measures.validity_start_date = quota_definitions.validity_start_date
           AND measures.additional_code_id ILIKE ?)
          eos
        end
    end
  end
end
