class MeasuresSearchForm

  attr_accessor MeasuresSearch::ALLOWED_FILTERS + [:page]

  def initialize(params)
    MeasuresSearch::ALLOWED_FILTERS.map do |filter_name|
      instance_variable_set("@#{filter_name}", params[filter_name])
    end
  end

  def status_list
    MeasureGroup::STATUS_LIST
  end

  def users
    User.all
  end

  def measure_types
    @measure_types ||= Rails.cache.fetch(:find_measures_form_measure_types, expires_in: 8.hours) do
      MeasureType.order(:measure_type_id)
    end
  end

  def geographical_areas
    @geographical_areas ||= Rails.cache.fetch(:find_measures_form_geo_areas, expires_in: 8.hours) do
      GeographicalArea.order(:geographical_area_id)
    end
  end

  def duty_expressions
    @duty_expressions ||= Rails.cache.fetch(:find_measures_form_duties, expires_in: 8.hours) do
      DutyExpression.order(:duty_expression_id)
    end
  end

  def conditions
    @conditions ||= Rails.cache.fetch(:find_measures_form_conditions, expires_in: 8.hours) do
      MeasureConditionCode.order(:condition_code)
    end
  end

  def footnote_types
    @footnote_types ||= Rails.cache.fetch(:find_measures_form_footnote_types, expires_in: 8.hours) do
      FootnoteType.order(:footnote_type_id)
    end
  end
end
