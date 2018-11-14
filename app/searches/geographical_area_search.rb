class GeographicalAreaSearch

  ALLOWED_FILTERS = %w(
    q
    start_date
    end_date
    code
  )

  attr_accessor :search_ops,
                :q,
                :start_date,
                :end_date,
                :code,
                :relation,
                :page

  def initialize(search_ops)
    @search_ops = search_ops
    @page = search_ops[:page] || 1
  end

  def results(paginate=true)
    @relation = GeographicalArea.default_order

    search_ops.select do |k, v|
      ALLOWED_FILTERS.include?(k.to_s) && v.present?
    end.each do |k, v|
      instance_variable_set("@#{k}", search_ops[k])
      send("apply_#{k}_filter")
    end

    apply_code_filter

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

    def apply_code_filter
      if codes.present?
        @relation = relation.by_code(codes)
      end
    end

    def apply_start_date_filter
      @relation = relation.after_or_equal(start_date.to_date.beginning_of_day)
    end

    def apply_end_date_filter
      @relation = relation.before_or_equal(end_date.to_date.end_of_day)
    end

    def codes
      codes_to_filter = []

      codes_to_filter << '0' if search_ops[:code_country].present?
      codes_to_filter << '1' if search_ops[:code_group].present?
      codes_to_filter << '2' if search_ops[:code_region].present?

      codes_to_filter
    end
end
