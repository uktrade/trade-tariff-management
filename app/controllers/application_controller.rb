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
