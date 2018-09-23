class WorkbasketsController < ApplicationController

  expose(:workbaskets) do
    current_user.workbaskets
  end

  def index
    params[:sort_by] ||= "last_status_change_at"
    params[:sort_dir] ||= "desc"
  end
end
