module Measures
  class MeasurementUnitsController < ::BaseController

    def collection
      MeasurementUnit.q_search(params)
    end
  end
end
