class WorkbasketsSearch
  ALLOWED_FILTERS = %w(
    q
  ).freeze

  FIELDS_ALLOWED_FOR_ORDER = %w(
    id
    title
    type
    status
    last_status_change_at
    operation_date
  ).freeze

  attr_accessor :current_user,
                :search_ops,
                :q,
                :sort_by_field,
                :relation,
                :page

  def initialize(current_user, search_ops = {})
    @current_user = current_user
    @search_ops = search_ops
    @page = search_ops[:page] || 1
    @sort_by_field = search_ops[:sort_by]
  end

  def results(with_pagination = true)
    setup_initial_scope!

    search_ops.select do |k, v|
      ALLOWED_FILTERS.include?(k) && v.present?
    end.each do |k, _v|
      instance_variable_set("@#{k}", search_ops[k])
      send("apply_#{k}_filter")
    end

    if with_pagination.present?
      relation.page(page)
    else
      relation
    end
  end

private

  def setup_initial_scope!
    @relation = if sort_by_field.present?
                  if FIELDS_ALLOWED_FOR_ORDER.include?(sort_by_field)
                    Workbaskets::Workbasket.custom_field_order(
                      sort_by_field, search_ops[:sort_dir]
                    )
                  else
                    Workbaskets::Workbasket.default_order
                  end

                else
                  Workbaskets::Workbasket.default_order
    end

    @relation = relation.default_filter
                        .relevant_for_manager(current_user)
  end

  def apply_q_filter
    @relation = relation.q_search(q)
  end
end
