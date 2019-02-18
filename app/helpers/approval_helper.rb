module ApprovalHelper
  def approval_title(workbasket)
    if workbasket.type == 'create_measures'
      'Approve new measures'
    elsif workbasket.type == 'create_quota'
      'Approve new quota'
    end
  end
end
