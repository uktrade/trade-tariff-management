module Quotas
  class Search
    include ::Shared::Search

    ALLOWED_FILTERS = %w(
      order_number
      description
      type
      regulation
      license
      staged
      commodity_code
      additional_code
      origin
      origin_exclusions
      valid_from
      valid_to
      status
      author
      date_of
      last_updated_by
    ).freeze

    attr_reader *(%i[relation search_ops page] + ALLOWED_FILTERS)

    def initialize(search_ops)
      @search_ops = search_ops
      @page = search_ops[:page] || 1
    end

    def results(paginated_query = true)
      @relation = QuotaDefinition.by_start_date_and_quota_definition_sid_reverse
      @relation = relation.page(page) if paginated_query
      search_ops.select do |k, v|
        ALLOWED_FILTERS.include?(k.to_s) &&
          v.present? &&
          v[:enabled].present?
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

    def quota_sids
      results(false).pluck(:quota_definition_sid)
    end

    def apply_order_number_filter
      @relation = relation.operator_search_by_order_number(
        *query_ops(order_number)
      )
    end

    def apply_description_filter
      @relation = relation.operator_search_by_description(
        *query_ops(description)
      )
    end

    def apply_type_filter
      @relation = relation.operator_search_by_type(
        *query_ops(type)
      )
    end

    def apply_regulation_filter
      @relation = relation.operator_search_by_regulation(
        *query_ops(regulation)
      )
    end

    def apply_license_filter
      @relation = relation.operator_search_by_license(
        *query_ops(license)
      )
    end

    def apply_staged_filter
      @relation = relation.operator_search_by_staged(
        *query_ops(staged)
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
  end
end
