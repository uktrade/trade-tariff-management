class Nomenclature::SectionChaptersController < ApplicationController
  respond_to :json
  around_action :configure_time_machine

  def index
    # TODO: We will need to get section chapters here instead of serving sections
    @sections = Section.all

    if @sections.present?
      render partial: "nomenclature/section_chapters"
    else
      head :not_found
    end
  end
end
