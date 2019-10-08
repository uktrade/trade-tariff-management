module ApprovalHelper
  def approval_title(workbasket)
    if workbasket.type == 'create_measures'
      'Approve and create measures'
    elsif workbasket.type == 'create_quota'
      'Approve and create quota'
    elsif workbasket.type == 'create_regulation'
      'Approve and create regulation'
    elsif workbasket.type == 'create_geographical_area'
      'Approve and create geographical area'
    elsif workbasket.type == 'create_additional_code'
      "Approve and create additional codes"
    elsif workbasket.type == 'create_certificate'
      "Approve and create certificate"
    elsif workbasket.type == 'bulk_edit_of_additional_codes'
      "Approve and bulk edit additional codes"
    elsif workbasket.type == 'edit_nomenclature'
      "Approve and create goods classification"
    elsif workbasket.type == 'create_footnote'
      "Approve and create footnotes"
    elsif workbasket.type == 'edit_footnote'
      "Approve and edit footnote"
    elsif workbasket.type == 'edit_geographical_area'
      "Approve and edit geographical area"
    elsif workbasket.type == 'bulk_edit_of_measures'
      "Approve and bulk edit measures"
    elsif workbasket.type == 'edit_regulation'
      "Approve and edit regulation"
    end
  end

  def approval_table_partial(workbasket)
    if workbasket.type == 'create_measures'
      "workbaskets/shared/steps/review_and_submit/approval/measures"
    elsif workbasket.type == 'create_quota'
      "workbaskets/shared/steps/review_and_submit/approval/quotas"
    elsif workbasket.type == 'create_regulation'
      "workbaskets/shared/steps/review_and_submit/approval/create_regulation"
    elsif workbasket.type == 'create_geographical_area'
      "workbaskets/shared/steps/review_and_submit/approval/geographical_areas"
    elsif workbasket.type == 'create_additional_code'
      "workbaskets/shared/steps/review_and_submit/approval/additional_code"
    elsif workbasket.type == 'edit_nomenclature'
      "workbaskets/shared/steps/review_and_submit/approval/edit_nomenclatures"
    elsif workbasket.type == 'bulk_edit_of_measures'
      "workbaskets/shared/steps/review_and_submit/approval/bulk_edit_measures"
    elsif workbasket.type == 'bulk_edit_of_additional_codes'
      "workbaskets/shared/steps/review_and_submit/approval/bulk_edit_additional_codes"
    elsif workbasket.type == 'edit_geographical_area'
      "workbaskets/shared/steps/review_and_submit/approval/geographical_areas"
    elsif workbasket.type == 'create_footnote'
      "workbaskets/shared/steps/review_and_submit/approval/create_footnote"
    elsif workbasket.type == 'edit_footnote'
      "workbaskets/shared/steps/review_and_submit/approval/edit_footnote"
    elsif workbasket.type == 'edit_regulation'
      "workbaskets/shared/steps/review_and_submit/approval/edit_regulation"
    elsif workbasket.type == 'create_certificate'
      "workbaskets/shared/steps/review_and_submit/approval/create_certificate"
    end
  end
end
