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
end
