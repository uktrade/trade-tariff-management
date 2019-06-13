class Nomenclature::SectionsController < ApplicationController
  respond_to :json
  around_action :configure_time_machine

  def index
    @sections = Section.all

    if @sections.present?
      render partial: "nomenclature/sections"
    else
      head :not_found
    end
  end
end
