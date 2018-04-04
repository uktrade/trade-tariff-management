module Measures
  class MeasurementUnitsController < ::BaseController

    def collection
      MeasurementUnit.actual
    end
  end
end
