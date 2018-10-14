class FootnoteSearch

  ALLOWED_FILTERS = %w(
    q
    footnote_type_id
    commodity_codes
    measure_sids
    start_date
    end_date
  )

  attr_accessor :search_ops,
                :q,
                :footnote_type_id,
                :commodity_codes,
                :measure_sids,
                :start_date,
                :end_date,
                :relation,
                :page

  def initialize(search_ops)
    @search_ops = search_ops
    @page = search_ops[:page] || 1
  end

  def results(paginate=true)
    @relation = Footnote.default_order

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

    def apply_q_filter
      @relation = relation.keywords_search(q)
    end

    def apply_footnote_type_id_filter
      @relation = relation.by_footnote_type_id(footnote_type_id)
    end

    def apply_commodity_codes_filter
      @relation = relation.by_commodity_codes(commodity_codes)
    end

    def apply_measure_sids_filter
      @relation = relation.by_measure_sids(measure_sids)
    end

    def apply_start_date_filter
      @relation = relation.after_or_equal(start_date.to_date.beginning_of_day)
    end

    def apply_end_date_filter
      @relation = relation.before_or_equal(end_date.to_date.end_of_day)
    end
end
