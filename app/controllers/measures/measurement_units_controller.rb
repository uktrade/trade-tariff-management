module Measures
  class MeasurementUnitsController < ::Measures::BaseController

    def collection
      MeasurementUnit.actual
    end
  end
end
