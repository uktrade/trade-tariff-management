module Measures
  class Search

    ALLOWED_FILTERS = %w(
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
    )

    attr_accessor *([:relation, :search_ops, :page] + ALLOWED_FILTERS)

    def initialize(search_ops)
      @search_ops = search_ops
      @page = search_ops[:page] || 1
    end

    def results
      #
      # TODO: remove .where("added_at IS NOT NULL") after testing
      #
      @relation = Measure.default_search.where("added_at IS NOT NULL")
      @relation = relation.operation_search_jsonb_default if jsonb_search_required?

      search_ops.select do |k, v|
        ALLOWED_FILTERS.include?(k.to_s) && v.present?
      end.each do |k, v|
        instance_variable_set("@#{k}", search_ops[k])
        send("apply_#{k}_filter")
      end

      relation.reverse_order(:validity_start_date)
              .page(page)
    end

    private

      def jsonb_search_required?
        group_name ||
        origin_exclusions ||
        duties ||
        conditions ||
        footnotes
      end

      def apply_group_name_filter
        @relation = relation.operator_search_by_group_name(
          *query_ops(group_name)
        )
      end

      def apply_status_filter
        @relation = relation.operator_search_by_status(
          *query_ops(status)
        )
      end

      def apply_author_filter
        @relation = relation.operator_search_by_author(author)
      end

      def apply_date_of_filter
        @relation = relation.operator_search_by_date_of(
          query_ops(date_of)
        )
      end

      def apply_last_updated_by_filter
        @relation = relation.operator_search_by_last_updated_by(last_updated_by)
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

      def query_ops(ops)
        if ops[:mode].present?
          ops
        else
          [
            ops[:operator],
            ops[:value]
          ]
        end
      end
  end
end
