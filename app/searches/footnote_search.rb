class FootnoteSearch

  ALLOWED_FILTERS = %w(
    q
    footnote_type_id
    commodity_codes
    measure_sids
    start_date
    end_date
  )

  FIELDS_ALLOWED_FOR_ORDER = %w(
    footnote_type_id
    footnote_id
    description
    validity_start_date
    validity_end_date
  )

  SIMPLE_SORTABLE_MODES = %w(
    footnote_type_id
    footnote_id
    validity_start_date
    validity_end_date
  )

  attr_accessor :search_ops,
                :q,
                :footnote_type_id,
                :commodity_codes,
                :measure_sids,
                :start_date,
                :end_date,
                :relation,
                :sort_by_field,
                :page

  def initialize(search_ops)
    @search_ops = search_ops
    @page = search_ops[:page] || 1
    @sort_by_field = search_ops[:sort_by]
  end

  def results(paginate=true)
    setup_initial_scope!

    search_ops.select do |k, v|
      ALLOWED_FILTERS.include?(k.to_s) && v.present?
    end.each do |k, v|
      instance_variable_set("@#{k}", search_ops[k])
      send("apply_#{k}_filter")
    end

    if paginate
      relation.page(page)
    else
      relation
    end
  end

  private

    def setup_initial_scope!
      @relation = if sort_by_field.present?
        if FIELDS_ALLOWED_FOR_ORDER.include?(sort_by_field)
          Footnote.custom_field_order(
            sort_by_field, search_ops[:sort_dir]
          )
        else
          Footnote.default_order
        end

      else
        Footnote.default_order
      end
    end

    def apply_q_filter
      @relation = relation.keywords_search(q)
    end

    def apply_footnote_type_id_filter
      @relation = relation.by_footnote_type_id(footnote_type_id)
    end

    def apply_commodity_codes_filter
      parsed_list = parse_list_of_values(commodity_codes)
      @relation = relation.by_commodity_codes(commodity_codes) unless commodity_codes.count.zero?
    end

    def apply_measure_sids_filter
      parsed_list = parse_list_of_values(measure_sids)
      @relation = relation.by_measure_sids(measure_sids) unless measure_sids.count.zero?
    end

    def apply_start_date_filter
      @relation = relation.after_or_equal(start_date.to_date.beginning_of_day)
    end

    def apply_end_date_filter
      @relation = relation.before_or_equal(end_date.to_date.end_of_day)
    end

    def parse_list_of_values(list_of_ids)
      # Split by linebreaks
      linebreaks_separated_list = list_of_ids.split(/\n+/)

      # Split by commas
      comma_separated_list = linebreaks_separated_list.map do |item|
        item.split(",")
      end.flatten

      # Split by whitespaces
      white_space_separated_list = comma_separated_list.map do |item|
        item.split(" ")
      end.flatten

      white_space_separated_list.map(&:squish)
                                .flatten
                                .reject { |i| i.blank? }.uniq
    end
end
