class CertificateSearch

  ALLOWED_FILTERS = %w(
    q
    certificate_type_code
    certificate_code
    start_date
    end_date
  )

  FIELDS_ALLOWED_FOR_ORDER = %w(
    certificate_type_code
    certificate_code
    description
    validity_start_date
    validity_end_date
  )

  SIMPLE_SORTABLE_MODES = %w(
    certificate_type_code
    certificate_code
    validity_start_date
    validity_end_date
  )

  attr_accessor :search_ops,
                :q,
                :certificate_type_code,
                :certificate_code,
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
      @relation = Certificate.default_order
    end

    def apply_q_filter
      @relation = relation.keywords_search(q)
    end

    def apply_certificate_type_code_filter
      @relation = relation.by_certificate_type_code(certificate_type_code)
    end

    def apply_certificate_code_filter
      @relation = relation.by_certificate_code(certificate_code)
    end

    def apply_start_date_filter
      @relation = relation.after_or_equal(start_date.to_date.beginning_of_day)
    end

    def apply_end_date_filter
      @relation = relation.before_or_equal(end_date.to_date.end_of_day)
    end

end
