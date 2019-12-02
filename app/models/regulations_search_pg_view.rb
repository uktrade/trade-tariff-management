class RegulationsSearchPgView < Sequel::Model(:regulations_search_pg_view)
  dataset_module do
    def default
      where("start_date IS NOT NULL")
    end

    def by_role(role)
      where(role: role)
    end

    def by_regulation_group_id(regulation_group_id)
      where(regulation_group_id: regulation_group_id)
    end

    def after_or_equal(start_date)
      where("start_date >= ?", start_date)
    end

    def before_or_equal(end_date)
      where("end_date IS NOT NULL AND end_date <= ?", end_date)
    end

    def q_search(keywords)
      q_rule = "%#{keywords}%"

      where(
        "regulation_id ilike ? OR keywords ilike ?",
        q_rule, q_rule
      )
    end

    def by_start_date_desc
      reverse_order(:start_date)
    end
  end

  class << self
    def max_per_page
      20
    end

    def default_per_page
      20
    end

    def max_pages
      999
    end
  end
end
