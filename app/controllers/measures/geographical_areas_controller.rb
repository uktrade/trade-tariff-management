module Measures
  class MeasureActionsController < ::BaseController

    def collection
      GeographicalArea.conditional_search(params)
    end
  end
end
