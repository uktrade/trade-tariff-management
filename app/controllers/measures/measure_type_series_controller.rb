module Measures
  class MeasureTypeSeriesController < ::BaseController

    def collection
      MeasureTypeSeries.q_search(params[:q])
    end
  end
end
