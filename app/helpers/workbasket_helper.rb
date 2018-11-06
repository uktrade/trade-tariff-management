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

  def create_additional_code_section_header
    case current_step
    when "main"
      "Create new additional codes"
    end
  end

  def create_footnote_section_header
    case current_step
    when "main"
      "Create a new footnote"
    end
  end

  def edit_footnote_section_header
    case current_step
    when "main"
      "Edit footnote"
    end
  end

  def edit_geographical_area_section_header
    case current_step
    when "main"
      "Edit geographical area"
    end
  end

  def edit_certificate_section_header
    case current_step
    when "main"
      "Edit certificate"
    end
  end

  def create_certificate_section_header
    case current_step
    when "main"
      "Add certificate"
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

  def edit_quota_section_header
    case current_step
    when "main"
      "Edit quota"
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

  def create_geographical_area_section_header
    case current_step
    when "main"
      "Add geographical area"
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

    when :create_quota, :clone_quota

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
        if workbasket.object.type.to_sym == :clone_quota && workbasket.title.blank?
          configure_cloned_quotas_bulk_url(
              workbasket.id
          )
        else
          edit_create_quotum_url(
              workbasket.id,
              step: :main
          )
        end
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

    when :create_additional_code
      edit_create_additional_code_url(
        workbasket.id,
        step: :main
      )

    when :create_certificate
      edit_create_certificate_url(
        workbasket.id,
        step: :main
      )

    when :bulk_edit_of_additional_codes

      if workbasket.settings.settings["title"].blank?
        work_with_selected_additional_codes_bulk_url(
            workbasket.id,
            search_code: workbasket.settings.search_code
        )

      else
        edit_additional_codes_bulk_url(
            workbasket.id,
            search_code: workbasket.settings.search_code
        )
      end

    when :bulk_edit_of_quotas

      if workbasket.settings.configure_step_settings["start_date"].blank?
        work_with_selected_quotas_bulk_url(
            workbasket.id
        )

      else
        if workbasket.settings.edit_quota_workbasket?
          if workbasket.settings.conditions_footnotes_step_validation_passed.present?
            edit_quotas_bulk_url(
                workbasket.id,
                step: :review_and_submit
            )

          elsif workbasket.settings.configure_quota_step_validation_passed.present?
            edit_quotas_bulk_url(
                workbasket.id,
                step: :conditions_footnotes
            )

          elsif workbasket.settings.main_step_validation_passed.present?
            edit_quotas_bulk_url(
                workbasket.id,
                step: :configure_quota
            )

          else
            edit_quotas_bulk_url(
                workbasket.id,
                step: :main
            )
          end
        else
          edit_quotas_bulk_url(
              workbasket.id,
              search_code: workbasket.settings.initial_search_results_code
          )
        end
      end

    when :create_geographical_area
      edit_create_geographical_area_url(
        workbasket.id,
        step: :main
      )

    when :create_footnote
      edit_create_footnote_url(
        workbasket.id,
        step: :main
      )

    when :edit_footnote
      edit_edit_footnote_url(
        workbasket.id,
        step: :main
      )

    when :edit_certificate
      edit_edit_certificate_url(
        workbasket.id,
        step: :main
      )

    when :edit_geographical_area
      edit_edit_geographical_area_url(
        workbasket.id,
        step: :main
      )

    end
  end

  def workbasket_view_link_based_on_type(workbasket)
    case workbasket.object.type.to_sym
    when :create_measures
      create_measure_url(workbasket.id)
    when :bulk_edit_of_measures
      bulk_edit_of_measure_url(workbasket.id, search_code: workbasket.settings.search_code)
    when :create_quota, :clone_quota
      create_quotum_url(workbasket.id)
    when :create_regulation
      create_regulation_url(workbasket.id)
    when :create_additional_code
      create_additional_code_url(workbasket.id)
    when :bulk_edit_of_additional_codes
      additional_codes_bulk_url(workbasket.id, search_code: workbasket.settings.search_code)
    when :bulk_edit_of_quotas
      if workbasket.settings.edit_quota_workbasket?
        quotas_bulk_url(workbasket.id)
      else
        quotas_bulk_url(workbasket.id, search_code: workbasket.settings.initial_search_results_code)
      end
    when :create_geographical_area
      create_geographical_area_url(workbasket.id)
    when :create_certificate
      create_certificate_url(workbasket.id)
    when :create_footnote
      create_footnote_url(workbasket.id)
    when :edit_footnote
      edit_footnote_url(workbasket.id)
    when :edit_certificate
      edit_certificate_url(workbasket.id)
    when :edit_geographical_area
      edit_geographical_area_url(workbasket.id)
    end
  end
end
