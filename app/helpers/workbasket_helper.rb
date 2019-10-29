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

  def edit_nomenclature_section_header
    case current_step
    when "main"
      "Work with selected commodity code"
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
      "Create a certificate"
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
      "Create a new regulation"
    when "review_and_submit"
      "Review and submit"
    end
  end

  def create_geographical_area_section_header
    case current_step
    when "main"
      "Create a new geographical area"
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
    ].reject(&:blank?).to_sentence

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

      if workbasket.settings.settings["start_date"].blank?
        work_with_selected_quotas_bulk_url(
          workbasket.id
        )

      else
        edit_quotas_bulk_url(
          workbasket.id
        )
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

    when :edit_nomenclature
      edit_edit_nomenclature_url(
        workbasket.id,
        step: :main
      )

    when :edit_regulation
      edit_edit_regulation_url(
        workbasket.id,
        step: :main
      )

    when :create_quota_association
      edit_create_quota_association_url(
        workbasket.id,
        step: :main
      )

    when :delete_quota_association
      edit_delete_quota_association_url(
        workbasket.id,
        step: :main
      )

    when :create_quota_suspension
      edit_create_quota_suspension_url(
        workbasket.id,
        step: :main
      )

    when :edit_quota_suspension
        edit_edit_quota_suspension_url(
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
      quotas_bulk_url(workbasket.id)
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
    when :create_nomenclature
      create_nomenclature_url(workbasket.id)
    when :edit_nomenclature
      edit_nomenclature_url(workbasket.id)
    when :edit_regulation
      edit_regulation_url(workbasket.id)
    when :bulk_edit_of_quotas_url
      edit_quotas_url(workbasket.id)
    when :create_quota_association
      create_quota_association_url(workbasket.id)
    when :delete_quota_association
      delete_quota_association_url(workbasket.id)
    when :create_quota_suspension
      create_quota_suspension_url(workbasket.id)
    when :edit_quota_suspension
      edit_quota_suspension_url(workbasket.id)
    end
  end

  def workbasket_edit_link(workbasket)
    if workbasket.object.type == "create_measures"
      withdraw_workbasket_from_workflow_create_measure_url(workbasket.id)
    elsif workbasket.object.type == "create_certificate"
      withdraw_workbasket_from_workflow_create_certificate_url(workbasket.id)
    elsif workbasket.object.type == "create_quota"
      withdraw_workbasket_from_workflow_create_quotum_url(workbasket.id)
    elsif workbasket.object.type == "create_regulation"
      withdraw_workbasket_from_workflow_create_regulation_url(workbasket.id)
    elsif workbasket.object.type == "bulk_edit_of_measures"
      withdraw_workbasket_from_workflow_bulk_edit_of_measure_url(workbasket.id)
    elsif workbasket.object.type == "create_additional_code"
      withdraw_workbasket_from_workflow_create_additional_code_url(workbasket.id)
    elsif workbasket.object.type == "bulk_edit_of_additional_codes"
      withdraw_workbasket_from_workflow_additional_codes_bulk_url(workbasket.id)
    elsif workbasket.object.type == "create_geographical_area"
      withdraw_workbasket_from_workflow_create_geographical_area_url(workbasket.id)
    elsif workbasket.object.type == "edit_geographical_area"
      withdraw_workbasket_from_workflow_edit_geographical_area_url(workbasket.id)
    elsif workbasket.object.type == "create_nomenclature"
      withdraw_workbasket_from_workflow_create_nomenclature_url(workbasket.id)
    elsif workbasket.object.type == "edit_nomenclature"
      withdraw_workbasket_from_workflow_edit_nomenclature_url(workbasket.id)
    elsif workbasket.object.type == "create_footnote"
      withdraw_workbasket_from_workflow_create_footnote_url(workbasket.id)
    elsif workbasket.object.type == "edit_footnote"
      withdraw_workbasket_from_workflow_edit_footnote_url(workbasket.id)
    elsif workbasket.object.type == "edit_regulation"
      withdraw_workbasket_from_workflow_edit_regulation_url(workbasket.id)
    elsif workbasket.object.type == "edit_certificate"
      withdraw_workbasket_from_workflow_edit_certificate_url(workbasket.id)
    elsif workbasket.object.type == "bulk_edit_of_quotas"
      withdraw_workbasket_from_workflow_bulk_edit_of_quotas_url(workbasket.id)
    elsif workbasket.object.type == "create_quota_association"
      withdraw_workbasket_from_workflow_create_quota_association_url(workbasket.id)
    elsif workbasket.object.type == "create_quota_suspension"
      withdraw_workbasket_from_workflow_create_quota_suspension_url(workbasket.id)
    elsif workbasket.object.type == "delete_quota_association"
      withdraw_workbasket_from_workflow_delete_quota_association_url(workbasket.id)
    end
  end

  def show_withdraw_edit?(workbasket)
    workbasket.can_withdraw? && @current_user.author_of_workbasket?(workbasket) && workbasket_edit_link(workbasket).present?
  end

  def show_delete?(workbasket)
     @current_user.author_of_workbasket?(workbasket) && (workbasket.editing? || workbasket.new_in_progress? || workbasket.cross_check_rejected? || workbasket.approval_rejected?)
  end

  def format_date(date)
    date&.strftime("%d/%m/%Y")
  end
end
