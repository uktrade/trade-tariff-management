module Measures
  class MeasureActionsController < ::BaseController
    def collection
      MeasureAction.q_search(params).eager(:measure_action_description).all
    end
  end
end
