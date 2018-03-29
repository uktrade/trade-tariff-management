module Measures
  class MeasurementUnitQualifiersController < ::Measures::BaseController

    def collection
      MeasurementUnitQualifier.actual
    end
  end
end
