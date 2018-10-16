class GeographicalAreaSearch

  ALLOWED_FILTERS = %w(
    q
    start_date
    end_date
    code_country
    code_region
    code_group
    code
  )

  attr_accessor :search_ops,
                :q,
                :start_date,
                :end_date,
                :code_country,
                :code_region,
                :code_group,
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

    if paginate
      relation.page(page)
    else
      relation
    end
  end

  private

    def apply_q_filter
      @relation = relation.q_search({ q: q })
    end

    def apply_code_filter
      @relation = relation.by_code(codes)
    end

    alias_method :apply_code_country_filter, :apply_code_filter
    alias_method :apply_code_region_filter, :apply_code_filter
    alias_method :apply_code_group_filter, :apply_code_filter

    def apply_start_date_filter
      @relation = relation.after_or_equal(start_date.to_date.beginning_of_day)
    end

    def apply_end_date_filter
      @relation = relation.before_or_equal(end_date.to_date.end_of_day)
    end

    def codes
      codes_to_filter = []

      codes_to_filter << '0' if code_country.present?
      codes_to_filter << '1' if code_group.present?
      codes_to_filter << '2' if code_region.present?

      codes_to_filter
    end
end
