module Measures
  module SearchFilters
    module FindMeasuresCollection

      include ::Shared::SearchFilters::FindCollection

      def by_start_date_and_measure_sid_reverse
        order(
          Sequel.desc(:validity_start_date),
          Sequel.desc(:measure_sid)
        )
      end

      def searchable_data_not_indexed
        where(
          "searchable_data_updated_at IS NULL OR searchable_data_updated_at::date < ?",
          Date.today.midnight.strftime("%Y-%m-%d")
        )
      end

      def operation_search_jsonb_default
        where("searchable_data::text <> '{}'::text")
      end

      def operator_search_by_measure_type(operator, measure_type_id=nil)
        is_or_is_not_search_query("measure_type_id", operator, measure_type_id)
      end

      def operator_search_by_origin(operator, geographical_area_id=nil)
        is_or_is_not_search_query("geographical_area_id", operator,  geographical_area_id)
      end

      def operator_search_by_commodity_code(operator, commodity_code=nil)
        operator_search_where_clause("CommodityCode", operator, commodity_code)
      end

      def operator_search_by_additional_code(operator, additional_code=nil)
        operator_search_where_clause("AdditionalCode", operator, additional_code)
      end

      def operator_search_by_regulation(operator, regulation_id=nil)
        operator_search_where_clause("Regulation", operator, regulation_id)
      end

      def operator_search_by_measure_sid(operator, measure_sid=nil)
        operator_search_where_clause("MeasureSid", operator, measure_sid)
      end

      def operator_search_by_group_name(operator, group_name=nil)
        operator_search_where_clause("GroupName", operator, group_name)
      end

      def operator_search_by_origin_exclusions(operator, exclusions_list=[])
        operator_search_where_clause("OriginExclusions", operator, exclusions_list)
      end

      def operator_search_by_duties(operator, duties_list=[])
        operator_search_where_clause("Duties", operator, duties_list)
      end

      def operator_search_by_conditions(operator, conditions_list=[])
        operator_search_where_clause("Conditions", operator, conditions_list)
      end

      def operator_search_by_footnotes(operator, footnotes_list=[])
        operator_search_where_clause("Footnotes", operator, footnotes_list)
      end

      def operator_search_by_order_number(operator, order_number=nil)
        is_or_is_not_search_query("ordernumber", operator,  order_number)
      end

      private

      def operator_search_where_clause(klass_name, operator, value=nil)
        q_rules = "::Measures::SearchFilters::#{klass_name}".constantize.new(
            operator, value
        ).sql_rules

        q_rules.present? ? where(q_rules) : self
      end

    end
  end
end
