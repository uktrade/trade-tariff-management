module ApprovalHelper
  def approval_title(workbasket)
    if workbasket.type == 'create_measures'
      'Approve new measures'
    elsif workbasket.type == 'create_quota'
      'Approve new quota'
    elsif workbasket.type == 'create_geographical_area'
      'Approve new geographical area'
    elsif workbasket.type == 'create_additional_code'
      "Approve new additional codes"
    elsif workbasket.type == 'edit_nomenclature'
      "Approve new goods classification"
    end
  end

  def approval_table_partial(workbasket)
    if workbasket.type == 'create_measures' || workbasket.type == 'bulk_edit_of_measures'
      "workbaskets/shared/steps/review_and_submit/approval/measures"
    elsif workbasket.type == 'create_quota'|| workbasket.type == 'edit_quota'
      "workbaskets/shared/steps/review_and_submit/approval/quotas"
    elsif workbasket.type == 'create_geographical_area' ||  workbasket.type == "edit_geographical_area"
      "workbaskets/shared/steps/review_and_submit/approval/geographical_areas"
    elsif workbasket.type == 'create_additional_code' || workbasket.type == 'bulk_edit_of_additional_codes'
      "workbaskets/shared/steps/review_and_submit/approval/additional_code"
    elsif workbasket.type == 'edit_nomenclature'
      "workbaskets/shared/steps/review_and_submit/approval/edit_nomenclatures"
    end
  end
end
