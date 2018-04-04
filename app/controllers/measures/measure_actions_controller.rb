module Measures
  class MeasureActionsController < ::BaseController

    def collection
      MeasureAction.actual
    end
  end
end
