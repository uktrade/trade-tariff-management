class RegulationsSearch
  ALLOWED_FILTERS = %w(
    role
    regulation_group_id
    start_date
    end_date
    keywords
    geographical_area_id
  ).freeze

  attr_accessor :search_ops,
                :role,
                :regulation_group_id,
                :start_date,
                :end_date,
                :keywords,
                :geographical_area_id,
                :relation,
                :page

  def initialize(search_ops)
    @search_ops = search_ops
    @page = search_ops[:page] || 1
  end

  def results
    @relation = RegulationsSearchPgView.default

    search_ops.select do |k, v|
      ALLOWED_FILTERS.include?(k.to_s) && v.present?
    end.each do |k, _v|
      instance_variable_set("@#{k}", search_ops[k])
      send("apply_#{k}_filter")
    end

    relation.page(page)
            .by_start_date_desc
  end

private

  def apply_role_filter
    @relation = relation.by_role(role)
  end

  def apply_regulation_group_id_filter
    @relation = relation.by_regulation_group_id(regulation_group_id)
  end

  def apply_start_date_filter
    @relation = relation.after_or_equal(start_date.to_date.beginning_of_day)
  end

  def apply_end_date_filter
    @relation = relation.before_or_equal(end_date.to_date.end_of_day)
  end

  def apply_keywords_filter
    @relation = relation.q_search(keywords)
  end

  def apply_geographical_area_id_filter
    # TODO
  end
end
