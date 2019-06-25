class Nomenclature::ChaptersController < ApplicationController
  respond_to :json
  around_action :configure_time_machine

  def show
    @chapter = Chapter.by_code(params[:id]).first
  end

end
