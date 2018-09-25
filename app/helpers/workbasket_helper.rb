module WorkbasketHelper
  def create_measures_section_header
    case current_step
    when "main"
      "Create measures"
    when "duties_conditions_footnotes"
      "Specify duties, conditions and footnotes"
    when "review_and_submit"
      "Review and submit"
    end
  end

  def create_quota_section_header
    case current_step
    when "main"
      "Create a quota"
    when "configure_quota"
      "Configure the quota"
    when "conditions_footnotes"
      "Specify conditions and footnotes (optional)"
    when "review_and_submit"
      "Review and submit"
    end
  end

  def create_regulation_section_header
    case current_step
    when "main"
      "Create a regulation"
    when "review_and_submit"
      "Review and submit"
    end
  end

  def workbasket_quota_periods_overview
    annual = workbasket_get_quota_periods('annual')
    bi_annual = workbasket_get_quota_periods('bi_annual')
    quarterly = workbasket_get_quota_periods('quarterly')
    monthly = workbasket_get_quota_periods('monthly')
    custom = workbasket_get_quota_periods('custom')

    message = [
      annual,
      bi_annual,
      quarterly,
      monthly,
      custom
    ].reject do |q|
      q.blank?
    end.to_sentence

    "#{message} #{'period'.pluralize(workbasket_settings.quota_periods.count)}"
  end

  def workbasket_get_quota_periods(type_of_quota)
    number_of_quotas = workbasket_settings.quota_periods_by_type(type_of_quota)
                                          .count

    unless number_of_quotas.zero?
      description = type_of_quota.split("_")
                                 .join("-")

      "#{number_of_quotas} #{description}"
    end
  end

  def workbasket_quota_periods_years_length
    pluralize(
      workbasket_settings.period_in_years, "year", "years"
    )
  end

  def workbasket_continue_link_based_on_type(workbasket)
    case workbasket.object.type.to_sym
    when :create_measures
      if workbasket.settings.duties_conditions_footnotes_step_validation_passed.present?
        edit_create_measure_url(
          workbasket.id,
          step: :review_and_submit
        )

      elsif workbasket.settings.main_step_validation_passed.present?
        edit_create_measure_url(
          workbasket.id,
          step: :duties_conditions_footnotes
        )

      else

        edit_create_measure_url(
          workbasket.id,
          step: :main
        )
      end

    when :bulk_edit_of_measures

      if workbasket.settings.settings["start_date"].blank?
        work_with_selected_measures_measures_bulk_url(
          workbasket.id,
          search_code: workbasket.settings.search_code
        )

      else
        edit_measures_bulk_url(
          workbasket.id,
          search_code: workbasket.settings.search_code
        )
      end

    when :create_quota

      if workbasket.settings.conditions_footnotes_step_validation_passed.present?
        edit_create_quotum_url(
          workbasket.id,
          step: :review_and_submit
        )

      elsif workbasket.settings.configure_quota_step_validation_passed.present?
        edit_create_quotum_url(
          workbasket.id,
          step: :conditions_footnotes
        )

      elsif workbasket.settings.main_step_validation_passed.present?
        edit_create_quotum_url(
          workbasket.id,
          step: :configure_quota
        )

      else
        edit_create_quotum_url(
          workbasket.id,
          step: :main
        )
      end


    when :create_regulation
      if workbasket.settings.main_step_validation_passed.present?
        edit_create_regulation_url(
          workbasket.id,
          step: :review_and_submit
        )

      else
        edit_create_regulation_url(
          workbasket.id,
          step: :main
        )
      end
    end
  end

  def workbasket_view_link_based_on_type(workbasket)
    case workbasket.object.type.to_sym
    when :create_measures
      create_measure_url(workbasket.id)
    when :bulk_edit_of_measures
      measures_bulk_url(workbasket.id, search_code: workbasket.settings.search_code)
    when :create_quota
      create_quotum_url(workbasket.id)
    when :create_regulation
      create_regulation_url(workbasket.id)
    end
  end
end
