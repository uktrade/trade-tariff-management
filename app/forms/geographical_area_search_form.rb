class GeographicalAreaSearchForm

  attr_accessor :q,
                :start_date,
                :end_date,
                :code

  def initialize(params)
    GeographicalAreaSearch::ALLOWED_FILTERS.map do |filter_name|
      instance_variable_set("@#{filter_name}", params[filter_name])
    end
  end
end
