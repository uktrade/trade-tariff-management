module CrossCheckHelper
  def cross_check_title(workbasket)
    if workbasket.type == 'create_measures'
      'Cross-check and create measures'
    elsif workbasket.type == 'create_quota'
      'Cross-check and create quota'
    end
  end
end
