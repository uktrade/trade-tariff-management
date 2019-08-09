class Nomenclature::SectionsController < ApplicationController
  respond_to :json
  around_action :configure_time_machine
  before_action :set_nomenclature_view_date

  def index
    @sections = Section.all
  end

  def show
    @section = Section.first(id: params[:id])
  end

end
