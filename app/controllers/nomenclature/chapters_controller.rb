class Nomenclature::ChaptersController < ApplicationController
  respond_to :json
  around_action :configure_time_machine

  def show
    set_nomenclature_view_date
    @chapter = Chapter.by_code(params[:id]).first
  end

end
