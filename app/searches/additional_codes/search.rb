module AdditionalCodes
  class Search

    def initialize(search_ops)
      @search_ops = search_ops
      @page = search_ops[:page] || 1
    end

    def results(paginated_query=true)
      # @relation = AdditionalCode.by_start_date_and_measure_sid_reverse
      # @relation = relation.page(page) if paginated_query
      # @relation = relation.operation_search_jsonb_default if jsonb_search_required?
      #
      # search_ops.select do |k, v|
      #   ALLOWED_FILTERS.include?(k.to_s) &&
      #       v.present? &&
      #       v[:enabled].present? &&
      #       collection_filter_is_missing_or_having_proper_values?(v)
      # end.each do |k, v|
      #   instance_variable_set("@#{k}", search_ops[k])
      #   send("apply_#{k}_filter")
      # end
      #
      # if Rails.env.development?
      #   p ""
      #   p "-" * 100
      #   p ""
      #   p " search_ops: #{search_ops.inspect}"
      #   p ""
      #   p " SQL: #{relation.sql}"
      #   p ""
      #   p "-" * 100
      #   p ""
      # end
      #
      AdditionalCode.order(
          Sequel.desc(:validity_start_date)
      )
    end

  end
end
