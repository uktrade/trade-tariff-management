module AdditionalCodes
  module SearchFilters
    module FindAdditionalCodesCollection

      include ::Shared::SearchFilters::FindCollection

      def by_start_date_and_additional_code_sid_reverse
        order(
            Sequel.desc(:validity_start_date),
            Sequel.desc(:additional_code_sid)
        )
      end

      def operator_search_by_additional_code_type(operator, additional_code_type_id=nil)
        is_or_is_not_search_query("additional_code_type_id", operator, additional_code_type_id)
      end

      def operator_search_by_code(operator, additional_code)
        operator_search_where_clause("AdditionalCode", operator, additional_code)
      end

      def operator_search_by_workbasket_name(operator, workbaket_name)
        operator_search_where_clause("WorkbasketName", operator, workbaket_name)
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
