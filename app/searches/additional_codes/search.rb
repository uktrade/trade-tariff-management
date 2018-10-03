module AdditionalCodes
  class Search

    include ::Shared::Search

    ALLOWED_FILTERS = %w(
      workbasket_name
      type
      code
      valid_from
      valid_to
      description
      status
      author
      date_of
      last_updated_by
    )

    attr_reader *([:relation, :search_ops, :page] + ALLOWED_FILTERS)

    def initialize(search_ops)
      @search_ops = search_ops
      @page = search_ops[:page] || 1
    end

    def results(paginated_query=true)
      @relation = AdditionalCode.by_start_date_and_additional_code_sid_reverse
      @relation = relation.page(page) if paginated_query
      # @relation = relation.operation_search_jsonb_default if jsonb_search_required?
      #
      search_ops.select do |k, v|
        ALLOWED_FILTERS.include?(k.to_s) &&
            v.present? &&
            v[:enabled].present?
      end.each do |k, v|
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

    def additional_code_sids
      results(false).pluck(:additional_code_sid)
    end

    private

    def apply_type_filter
      @relation = relation.operator_search_by_additional_code_type(
          *query_ops(type)
      )
    end

    def apply_code_filter
      @relation = relation.operator_search_by_code(
          *query_ops(code)
      )
    end

    def apply_workbasket_name_filter
      @relation = relation.operator_search_by_workbasket_name(
          *query_ops(workbasket_name)
      )
    end

    def apply_description_filter
      @relation = relation.operator_search_by_description(
          *query_ops(description)
      )
    end

  end
end
