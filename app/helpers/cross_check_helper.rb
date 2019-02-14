module CrossCheckHelper
  def cross_check_title(workbasket)
    if workbasket.type == 'create_measures'
      'Cross-check and create measures'
    elsif workbasket.type == 'create_quota'
      'Cross-check and create quota'
    end
  end

  def table_partial(workbasket)
    if workbasket.type == 'create_measures'
      "workbaskets/shared/steps/review_and_submit/measures"
    elsif workbasket.type == 'create_quota'
      "workbaskets/shared/steps/review_and_submit/quotas"
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
