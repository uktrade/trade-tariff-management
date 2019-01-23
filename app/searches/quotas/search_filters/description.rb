module Quotas
  module SearchFilters
    class Description
      attr_accessor :operator,
                    :description

      def initialize(operator, description = nil)
        @operator = operator
        @description = description.to_s.strip
      end

      def sql_rules
        return nil if description.blank?

        clause
      end

    private

      def clause
        case operator
        when "is"

          [is_clause, value]
        when "starts_with"

          [like_clause, value]
        when "contains"

          [like_clause, value]
        end
      end

      def value
        if operator == "starts_with"
          "#{description}%"
        elsif operator == "contains"
          "%#{description}%"
        else
          description
        end
      end

      def is_clause
        <<-eos
            quota_definitions.description = ?
        eos
      end

      def like_clause
        <<-eos
            quota_definitions.description ilike ?
        eos
      end
    end
  end
end
