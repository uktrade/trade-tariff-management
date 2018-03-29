module Measures
  class MeasureTypeSeriesController < ::Measures::BaseController

    def collection
      MeasureTypeSeries.actual
    end
  end
end
