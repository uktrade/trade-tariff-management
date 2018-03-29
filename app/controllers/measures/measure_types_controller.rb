module Measures
  class MeasureTypesController < ::Measures::BaseController

    def collection
      MeasureType.actual
    end
  end
end
