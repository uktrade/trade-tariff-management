module AdditionalCodes
  module SearchFilters
    class WorkbasketName
      attr_accessor :operator,
                    :workbasket_name

      def initialize(operator, workbasket_name = nil)
        @operator = operator
        @workbasket_name = workbasket_name.to_s.strip
      end

      def sql_rules
        return nil if workbasket_name.blank?

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
          "#{workbasket_name}%"
        elsif operator == "contains"
          "%#{workbasket_name}%"
        else
          workbasket_name
        end
      end

      def is_clause
        <<-eos
            workbaskets.title = ?
        eos
      end

      def like_clause
        <<-eos
            workbaskets.title ilike ?
        eos
      end
    end
  end
end
