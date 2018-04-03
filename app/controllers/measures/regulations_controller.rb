module Measures
  class RegulationsController < ::Measures::BaseController

    def collection
      BaseRegulation.actual
                    .not_replaced_and_partially_replaced
                    .q_search(params[:q])
                    .limit(100)
    end
  end
end
