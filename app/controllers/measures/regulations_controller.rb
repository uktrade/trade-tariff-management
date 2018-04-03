module Measures
  class RegulationsController < ::Measures::BaseController

    def collection
      BaseRegulation.actual
                    .q_search(params[:q])
                    .limit(100)
    end
  end
end
