class HealthcheckController < ActionController::Base
  protect_from_forgery

  def index
    render json: { git_sha1: CURRENT_RELEASE_SHA }
  end
end
