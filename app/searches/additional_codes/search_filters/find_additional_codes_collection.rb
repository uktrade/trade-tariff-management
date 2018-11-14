module AdditionalCodes
  module SearchFilters
    module FindAdditionalCodesCollection

      include ::Shared::SearchFilters::FindCollection

      def by_start_date_and_additional_code_sid_reverse
        order(
            Sequel.desc(:all_additional_codes__validity_start_date),
            Sequel.desc(:all_additional_codes__additional_code_sid)
        )
      end

      def operator_search_by_additional_code_type(operator, additional_code_type_id=nil)
        is_or_is_not_search_query("additional_code_type_id", operator, additional_code_type_id)
      end

      def operator_search_by_code(operator, additional_code)
        operator_search_where_clause("AdditionalCode", operator, additional_code)
      end

      def operator_search_by_workbasket_name(operator, workbasket_name)
        q_rules = ::AdditionalCodes::SearchFilters::WorkbasketName.new(
            operator, workbasket_name
        ).sql_rules
        q_rules.present? ? self.join(:workbaskets, id: :all_additional_codes__workbasket_id).where(q_rules) : self
      end

      def operator_search_by_description(operator, description)
        operator_search_where_clause("Description", operator, additional_code)
      end

      private

      def operator_search_where_clause(klass_name, operator, value=nil)
        q_rules = "::AdditionalCodes::SearchFilters::#{klass_name}".constantize.new(
            operator, value
        ).sql_rules

        q_rules.present? ? where(q_rules) : self
      end

    end
  end
end
