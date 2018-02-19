class HealthcheckController < ApplicationController
  def index
    render json: { git_sha1: CURRENT_RELEASE_SHA }
  end
end
