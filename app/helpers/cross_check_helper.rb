module CrossCheckHelper
  def cross_check_title(workbasket)
    if workbasket.type == 'create_measures'
      'Cross-check and create measures'
    elsif workbasket.type == 'create_quota'
      'Cross-check and create quota'
    elsif workbasket.type == 'create_geographical_area'
      'Cross-check and create geographical area'
    elsif workbasket.type == 'create_additional_code'
      "Cross-check and create additional codes"
    elsif workbasket.type == 'edit_nomenclature'
      "Cross-check and edit goods classification"
    end
  end

  def table_partial(workbasket)
    if workbasket.type == 'create_measures'
      "workbaskets/shared/steps/review_and_submit/measures"
    elsif workbasket.type == 'create_quota'
      "workbaskets/shared/steps/review_and_submit/quotas"
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
