module Shared
  module Search
    def apply_status_filter
      @relation = relation.operator_search_by_status(
        *query_ops(status)
      )
    end

    def apply_author_filter
      val = just_value(author)
      @relation = relation.operator_search_by_author(val) if val.present?
    end

    def apply_last_updated_by_filter
      val = just_value(last_updated_by)
      @relation = relation.operator_search_by_last_updated_by(val) if val.present?
    end

    def apply_date_of_filter
      @relation = relation.operator_search_by_date_of(
        query_ops(date_of)
      )
    end

    def apply_valid_from_filter
      @relation = relation.operator_search_by_valid_from(
        *query_ops(valid_from)
      )
    end

    def apply_valid_to_filter
      @relation = relation.operator_search_by_valid_to(
        *query_ops(valid_to)
      )
    end

    def query_ops(ops)
      val = just_value(ops)

      if ops[:mode].present?
        ops
      else
        [
            ops[:operator],
            val.is_a?(Hash) ? val.values : val
        ]
      end
    end

    def just_value(ops)
      ops[:value]
    end
  end
end
