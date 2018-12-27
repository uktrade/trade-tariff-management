module Measures
  class MeasurementUnitsController < ::BaseController
    def collection
      MeasurementUnit.q_search(params).eager(:measurement_unit_description, :measurement_unit_abbreviations).all
    end
  end
end
