module Measures
  class MeasureTypeSeriesController < ::BaseController

    def collection
      MeasureTypeSeries.actual
    end
  end
end
