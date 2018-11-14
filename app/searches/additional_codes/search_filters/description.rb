module AdditionalCodes
  module SearchFilters
    class Description

      OPERATORS_WITH_REQUIRED_PARAMS = %w(
        is
        is_not
        starts_with
      )

      attr_accessor :operator,
                    :description

      def initialize(operator, description=nil)
        @operator = operator
        @description = description.to_s.strip
      end

      def sql_rules
        return nil if required_options_are_blank?

        clause
      end

      private

      def required_options_are_blank?
        OPERATORS_WITH_REQUIRED_PARAMS.include?(operator) &&
            description.blank?
      end

      def clause
        case operator
          when "is"

            [ is_clause, value ]
          when "is_not"

            [ is_not_clause, value ]
          when "is_not_specified"

            is_not_specified_clause
          when "is_not_unspecified"

            is_not_unspecified_clause
          when "starts_with"

            [ starts_with_clause, value ]
        end
      end

      def value
        if operator == "starts_with"
          "#{description}%"
        else
          description
        end
      end

      def is_clause
        <<-eos
            all_additional_codes.description = ?
        eos
      end

      def is_not_clause
        <<-eos
            #{is_not_specified_clause} OR
            all_additional_codes.description != ?
        eos
      end

      def starts_with_clause
        <<-eos
            all_additional_codes.description ilike ?
        eos
      end

      def is_not_specified_clause
        <<-eos
            all_additional_codes.description IS NULL
        eos
      end

      def is_not_unspecified_clause
        <<-eos
            all_additional_codes.description IS NOT NULL
        eos
      end
    end
  end
end