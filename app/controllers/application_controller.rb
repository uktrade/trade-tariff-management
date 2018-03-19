class ApplicationController < ActionController::Base
  include Pundit
  include GDS::SSO::ControllerMethods

  protect_from_forgery

  prepend_before_action :authenticate_user!
  before_action :require_signin_permission!
  around_action :configure_time_machine

  rescue_from Pundit::NotAuthorizedError do |e|
    # Layout and view comes from GDS::SSO::ControllerMethods
    render "authorisations/unauthorised", layout: "unauthorised", status: :forbidden, locals: { message: e.message }
  end unless Rails.env.test?

  def current_page
    Integer(params[:page] || 1)
  end

  private

  # NOTE: if we ever decide to bring time travel like tariff backend, it's best if we keep this method to determine the "current date"
  def actual_date
    Date.current
  end
  helper_method :actual_date

  def configure_time_machine
    TimeMachine.at(actual_date) do
      yield
    end
  end
end
