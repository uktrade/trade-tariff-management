class ApplicationController < ActionController::Base

  include AuthHelper

  protect_from_forgery with: :null_session

  before_action :authenticate_user!

  # prepend_before_action :authenticate_user! before_action do
  #   authorise_user!('signin')
  # end

  def current_page
    Integer(params[:page] || 1)
  end

  def set_nomenclature_view_date
    if params[:date].present?
      selected_date = params[:date]
      @view_date = Date.new selected_date["year"].to_i, selected_date["month"].to_i, selected_date["day"].to_i
      if @view_date == Date.today
        cookies.delete :nomenclature_view_date
      else
        cookies[:nomenclature_view_date] = @view_date
      end
    elsif cookies[:nomenclature_view_date].present?
      @view_date = Date.parse(cookies[:nomenclature_view_date])
    else
      @view_date = Date.today
    end
  end

  private

  def actual_date
    Date.parse(params[:start_date].to_s)
  rescue ArgumentError
    Date.current
  end
  helper_method :actual_date

  def configure_time_machine
    TimeMachine.at(actual_date) do
      yield
    end
  end
end
