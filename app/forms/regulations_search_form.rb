class RegulationsSearchForm
  attr_accessor :role,
                :regulation_group_id,
                :start_date,
                :end_date,
                :keywords,
                :geographical_area_id

  def initialize(params)
    RegulationsSearch::ALLOWED_FILTERS.map do |filter_name|
      instance_variable_set("@#{filter_name}", params[filter_name])
    end
  end

  def roles
    ::WorkbasketForms::CreateRegulationForm.new(nil).regulation_roles
  end

  def regulation_groups
    RegulationGroup.by_description
                   .all
  end

  def geographical_areas
    GeographicalArea.all
  end
end
