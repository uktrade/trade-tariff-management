module AdditionalCodes
  module SearchFilters
    class Description
      OPERATORS_WITH_REQUIRED_PARAMS = %w(
        contains
      ).freeze

      attr_accessor :operator,
                    :description

      def initialize(operator, description = nil)
        @operator = operator
        @description = description.to_s.strip
      end

      def sql_rules
        return nil if required_options_are_blank?

        [contains_clause, description]
      end

    private

      def required_options_are_blank?
        OPERATORS_WITH_REQUIRED_PARAMS.include?(operator) &&
          description.blank?
      end

      def contains_clause
        <<-eos
            all_additional_codes.description ILIKE '%' || ? || '%'
        eos
      end
    end
  end
end
