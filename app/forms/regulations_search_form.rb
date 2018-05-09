class RegulationsSearchForm

  attr_accessor :start_date,
                :end_date,
                :regulation_group_id,
                :geographical_area_id,
                :keywords

  def initialize(params)
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @regulation_group_id = params[:regulation_group_id]
    @geographical_area_id = params[:geographical_area_id]
    @keywords = params[:keywords]
  end

  def regulation_groups
    RegulationGroup.all
  end

  def geographical_areas
    GeographicalArea.all
  end
end
