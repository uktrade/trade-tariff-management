module Measures
  class MeasureActionsController < ::Measures::BaseController

    def collection
      MeasureAction.actual
    end
  end
end
