class WorkbasketsController < ApplicationController

  around_action :configure_time_machine

  expose(:workbaskets) do
    ::WorkbasketsSearch.new(
      current_user, params
    ).results
  end

  def index
    params[:sort_by] ||= "last_status_change_at"
    params[:sort_dir] ||= "desc"
  end
end
