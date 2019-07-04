module WorkbasketWorkflowHelper
  def workbasket_event_date(date)
    date.created_at
        .strftime("%d %B %Y")
  end

  def workbasket_rejected?
    workbasket.cross_check_rejected? ||
      workbasket.approval_rejected?
  end

  def workbasket_awaiting_cross_check_or_rejected?
    workbasket.awaiting_cross_check? ||
      workbasket.cross_check_rejected?
  end

  def workbasket_view_show_actions_allowed?
    workbasket.awaiting_cross_check? ||
      workbasket.ready_for_export? ||
      workbasket.awaiting_cds_upload_create_new?
  end

  def workbasket_status_in_error_level?
    Workbaskets::Workbasket::STATES_WITH_ERROR.include?(
      workbasket.status.to_sym
    )
  end

  def iam_workbasket_author?
    workbasket.user_id == @current_user.id
  end

  def underlying_object_link
    if workbasket.type.include?("geographical_area")
      link_to "Geographical Areas", geo_areas_url
    elsif workbasket.type.include?("additional_code")
      link_to "Additional Codes", additional_codes_url
    elsif workbasket.type.include?("quot")
      link_to "Quotas", quotas_url
    else
      link_to "Measures", measures_url
    end
  end
end
