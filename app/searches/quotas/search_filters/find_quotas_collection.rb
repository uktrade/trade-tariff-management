module Quotas
  module SearchFilters
    module FindQuotasCollection
      include ::Shared::SearchFilters::FindCollection

      def by_start_date_and_quota_definition_sid_reverse
        where(status: 'published').
        order(
          Sequel.desc(:quota_definitions__quota_order_number_id),
            Sequel.desc(:quota_definitions__validity_start_date)
        )
      end

      def operator_search_by_order_number(operator, order_number = nil)
        operator_search_where_clause("OrderNumber", operator, order_number)
      end

      def operator_search_by_description(operator, description = nil)
        operator_search_where_clause("Description", operator, description)
      end

      def operator_search_by_type(operator, type = nil)
        operator_search_where_clause("Type", operator, type)
      end

      def operator_search_by_regulation(operator, regulation = nil)
        operator_search_where_clause("Regulation", operator, regulation)
      end

      def operator_search_by_license(operator, license = nil)
        operator_search_where_clause("License", operator, license)
      end

      def operator_search_by_staged(operator, _dummy = nil)
        operator_search_where_clause("Staged", operator, nil)
      end

      def operator_search_by_commodity_code(operator, commodity_code = nil)
        operator_search_where_clause("CommodityCode", operator, commodity_code)
      end

      def operator_search_by_additional_code(operator, additional_code = nil)
        operator_search_where_clause("AdditionalCode", operator, additional_code)
      end

      def operator_search_by_origin(operator, origin = nil)
        operator_search_where_clause("Origin", operator, origin)
      end

      def operator_search_by_origin_exclusions(operator, origin_exclusions = nil)
        operator_search_where_clause("OriginExclusions", operator, origin_exclusions)
      end

    private

      def operator_search_where_clause(klass_name, operator, value = nil)
        q_rules = "::Quotas::SearchFilters::#{klass_name}".constantize.new(
          operator, value
        ).sql_rules

        q_rules.present? ? where(q_rules) : self
      end
    end
  end
end
