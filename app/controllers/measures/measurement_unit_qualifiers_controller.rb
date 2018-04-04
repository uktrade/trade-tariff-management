module Measures
  class MeasurementUnitQualifiersController < ::BaseController

    def collection
      MeasurementUnitQualifier.actual
    end
  end
end
