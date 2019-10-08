module CrossCheckHelper
  def cross_check_title(workbasket)
    if workbasket.type == 'create_measures'
      'Cross-check and create measures'
    elsif workbasket.type == 'create_quota'
      'Cross-check and create quota'
    elsif workbasket.type == 'create_regulation'
      "Cross-check and create regulation"
    elsif workbasket.type == 'create_geographical_area'
      'Cross-check and create geographical area'
    elsif workbasket.type == 'create_additional_code'
      "Cross-check and create additional codes"
    elsif workbasket.type == 'create_certificate'
      "Cross-check and create certificate"
    elsif workbasket.type == 'edit_nomenclature'
      "Cross-check and edit goods classification"
    elsif workbasket.type == 'edit_geographical_area'
      "Cross-check and edit geographical area"
    elsif workbasket.type == 'bulk_edit_of_measures'
      "Cross-check and bulk edit measures"
    elsif workbasket.type == 'bulk_edit_of_additional_codes'
      "Cross-check and bulk edit additional codes"
    elsif workbasket.type == 'create_footnote'
      "Cross-check and create footnote"
    elsif workbasket.type == 'edit_footnote'
      "Cross-check and edit footnote"
    elsif workbasket.type == 'edit_regulation'
      "Cross-check and edit regulation"
    end
  end

  def table_partial(workbasket)
    if workbasket.type == 'create_measures'
      "workbaskets/shared/steps/review_and_submit/measures"
    elsif workbasket.type == 'create_quota'
      "workbaskets/shared/steps/review_and_submit/quotas"
    elsif workbasket.type == 'create_regulation'
      "workbaskets/shared/steps/review_and_submit/regulation"
    elsif workbasket.type == 'bulk_edit_of_measures'
      "workbaskets/shared/steps/review_and_submit/bulk_edit_measures"
    elsif workbasket.type == 'create_geographical_area'
      "workbaskets/shared/steps/review_and_submit/geographical_areas"
    elsif workbasket.type == 'edit_geographical_area'
      "workbaskets/shared/steps/review_and_submit/geographical_areas"
    elsif workbasket.type == 'create_additional_code'
      "workbaskets/shared/steps/review_and_submit/additional_code"
    elsif workbasket.type == 'bulk_edit_of_additional_codes'
      "workbaskets/shared/steps/review_and_submit/bulk_edit_additional_codes"
    elsif workbasket.type == 'edit_nomenclature'
      "workbaskets/shared/steps/review_and_submit/edit_nomenclatures"
    elsif workbasket.type == 'create_footnote'
      "workbaskets/shared/steps/review_and_submit/create_footnote"
    elsif workbasket.type == 'edit_footnote'
      "workbaskets/shared/steps/review_and_submit/edit_footnote"
    elsif workbasket.type == 'edit_regulation'
      "workbaskets/shared/steps/review_and_submit/edit_regulation"
    elsif workbasket.type == 'create_certificate'
      "workbaskets/shared/steps/review_and_submit/create_certificate"
    end
  end

  def object_name(workbasket)
    if workbasket.type == 'create_measures'
      "measure(s)"
    elsif workbasket.type == 'create_quota'
      "quota"
    end
  end
end
