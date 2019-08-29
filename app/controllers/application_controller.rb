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
    if params[:nomenclature_date].present?
      selected_date = params[:nomenclature_date]
      @view_date = Date.new selected_date["year"].to_i, selected_date["month"].to_i, selected_date["day"].to_i
    else
      @view_date = Date.today
    end
  end

  private

  def actual_date
    if params[:nomenclature_date].present?
      selected_date = params[:nomenclature_date]
      Date.new selected_date["year"].to_i, selected_date["month"].to_i, selected_date["day"].to_i
    else
      Date.parse(params[:start_date].to_s)
    end

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
