module Measures
  class RegulationsController < ::Measures::BaseController

    def collection
      BaseRegulation.actual
                    .fully_replaced
                    .q_search(params[:q])
                    .limit(100)
    end
  end
end
