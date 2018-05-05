module Measures
  class MeasureActionsController < ::BaseController

    def collection
      MeasureAction.q_search(params)
    end
  end
end
