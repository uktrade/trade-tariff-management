class RegulationsSearchPgView  < Sequel::Model(:regulations_search_pg_view)

  dataset_module do
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
      where(Sequel.ilike(:keywords, "#{keywords}%"))
    end
  end
end
