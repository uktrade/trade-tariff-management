module Measures
  class MeasurementUnitQualifiersController < ::BaseController

    def collection
      MeasurementUnitQualifier.q_search(params)
    end
  end
end
