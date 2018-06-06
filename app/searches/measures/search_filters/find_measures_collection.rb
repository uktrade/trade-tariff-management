module Measures
  module SearchFilters
    module FindMeasuresCollection
      def operation_search_jsonb_default
        where("searchable_data::text <> '{}'::text")
      end

      def operator_search_by_status(operator, status=nil)
        is_or_is_not_search_query("status", operator, status)
      end

      def operator_search_by_measure_type(operator, measure_type_id=nil)
        is_or_is_not_search_query("measure_type_id", operator, measure_type_id)
      end

      def operator_search_by_origin(operator, geographical_area_id=nil)
        is_or_is_not_search_query("geographical_area_id", operator,  geographical_area_id)
      end

      def operator_search_by_date_of(ops={})
        q_rules = ::Measures::SearchFilters::DateOf.new(ops).sql_rules
        q_rules.present? ? where(q_rules) : self
      end

      def operator_search_by_valid_from(operator, date=nil)
        date_filter_search_query("validity_start_date", operator, date)
      end

      def operator_search_by_valid_to(operator, date=nil)
        date_filter_search_query("validity_end_date", operator, date)
      end

      def operator_search_by_author(user_id)
        where(added_by_id: user_id)
      end

      def operator_search_by_last_updated_by(user_id)
        where(last_update_by_id: user_id)
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

      private

        def operator_search_where_clause(klass_name, operator, value=nil)
          q_rules = "::Measures::SearchFilters::#{klass_name}".constantize.new(
            operator, value
          ).sql_rules

          q_rules.present? ? where(q_rules) : self
        end

        def date_filter_search_query(field_name, operator, date)
          q_rules = ::Measures::SearchFilters::DateUniversal.new(
            field_name, operator, date
          ).sql_rules

          q_rules.present? ? where(q_rules) : self
        end

        def is_or_is_not_search_query(field_name, operator, value=nil)
          return self if value.blank?

          q_rule = if operator == "is"
            "#{field_name} = ?"
          else
            "#{field_name} IS NULL OR #{field_name} != ?"
          end

          where(q_rule, value)
        end
    end
  end
end
