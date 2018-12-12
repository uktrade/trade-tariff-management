module Shared
  module SearchFilters
    module FindCollection
      def operator_search_by_status(operator, status = nil)
        is_or_is_not_search_query("status", operator, status)
      end

      def operator_search_by_date_of(ops = {})
        q_rules = ::Shared::SearchFilters::DateOf.new(ops).sql_rules
        q_rules.present? ? where(q_rules) : self
      end

      def operator_search_by_valid_from(operator, date = nil)
        date_filter_search_query("validity_start_date", operator, date)
      end

      def operator_search_by_valid_to(operator, date = nil)
        date_filter_search_query("validity_end_date", operator, date)
      end

      def operator_search_by_author(user_id)
        where(added_by_id: user_id)
      end

      def operator_search_by_last_updated_by(user_id)
        where(last_update_by_id: user_id)
      end

    private

      def date_filter_search_query(field_name, operator, date)
        q_rules = ::Shared::SearchFilters::DateUniversal.new(
          field_name, operator, date
        ).sql_rules

        q_rules.present? ? where(q_rules) : self
      end

      def is_or_is_not_search_query(field_name, operator, value = nil)
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
