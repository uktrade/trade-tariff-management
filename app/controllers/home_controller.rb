class HomeController < ApplicationController
  def index
    params[:sort_by] ||= "last_status_change_at"
    params[:sort_dir] ||= "desc"
  end
end
