module Measures
  class Search
    include ::Shared::Search

    ALLOWED_FILTERS = %w(
      measure_sid
      group_name
      status
      author
      date_of
      last_updated_by
      regulation
      type
      valid_from
      valid_to
      commodity_code
      additional_code
      origin
      origin_exclusions
      duties
      conditions
      footnotes
      order_number
    ).freeze

    attr_accessor *(%i[relation search_ops page] + ALLOWED_FILTERS)

    def initialize(search_ops)
      @search_ops = search_ops
      @page = search_ops[:page] || 1
    end

    def results(paginated_query = true)
      @relation = Measure.by_start_date_and_measure_sid_reverse
      @relation = relation.page(page) if paginated_query
      @relation = relation.operation_search_jsonb_default if jsonb_search_required?

      search_ops.select do |k, v|
        ALLOWED_FILTERS.include?(k.to_s) &&
          v.present? &&
          v[:enabled].present? &&
          collection_filter_is_missing_or_having_proper_values?(v)
      end.each do |k, _v|
        instance_variable_set("@#{k}", search_ops[k])
        send("apply_#{k}_filter")
      end

      if Rails.env.development?
        p ""
        p "-" * 100
        p ""
        p " search_ops: #{search_ops.inspect}"
        p ""
        p " SQL: #{relation.sql}"
        p ""
        p "-" * 100
        p ""
      end

      relation
    end

    def measure_sids
      results(false).pluck(:measure_sid)
    end

  private

    def collection_filter_is_missing_or_having_proper_values?(v)
      val = v[:value]
      return true if val.blank?

      !val.is_a?(Hash) ||
        (
          val.is_a?(Hash) && val.values.reject(&:blank?).present?
        )
    end

    def jsonb_search_required?
      group_name ||
        regulation ||
        origin_exclusions ||
        duties ||
        conditions ||
        footnotes
    end

    def apply_measure_sid_filter
      @relation = relation.operator_search_by_measure_sid(
        *query_ops(measure_sid)
      )
    end

    def apply_group_name_filter
      @relation = relation.operator_search_by_group_name(
        *query_ops(group_name)
      )
    end

    def apply_regulation_filter
      @relation = relation.operator_search_by_regulation(
        *query_ops(regulation)
      )
    end

    def apply_type_filter
      @relation = relation.operator_search_by_measure_type(
        *query_ops(type)
      )
    end

    def apply_commodity_code_filter
      @relation = relation.operator_search_by_commodity_code(
        *query_ops(commodity_code)
      )
    end

    def apply_additional_code_filter
      @relation = relation.operator_search_by_additional_code(
        *query_ops(additional_code)
      )
    end

    def apply_origin_filter
      @relation = relation.operator_search_by_origin(
        *query_ops(origin)
      )
    end

    def apply_origin_exclusions_filter
      @relation = relation.operator_search_by_origin_exclusions(
        *query_ops(origin_exclusions)
      )
    end

    def apply_duties_filter
      @relation = relation.operator_search_by_duties(
        *query_ops(duties)
      )
    end

    def apply_conditions_filter
      @relation = relation.operator_search_by_conditions(
        *query_ops(conditions)
      )
    end

    def apply_footnotes_filter
      @relation = relation.operator_search_by_footnotes(
        *query_ops(footnotes)
      )
    end

    def apply_order_number_filter
      @relation = relation.operator_search_by_order_number(
        *query_ops(order_number)
      )
    end
  end
end
