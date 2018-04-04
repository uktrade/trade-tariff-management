module Measures
  class MeasureTypesController < ::BaseController

    def collection
      MeasureType.actual
    end
  end
end
