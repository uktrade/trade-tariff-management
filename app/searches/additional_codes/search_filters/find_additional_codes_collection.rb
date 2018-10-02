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

      def operator_search_by_code(value)
        where(additional_code: value)
      end

    end
  end
end
