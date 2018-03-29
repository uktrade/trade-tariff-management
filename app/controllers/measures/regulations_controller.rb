module Measures
  class RegulationsController < ::Measures::BaseController

    def collection
      BaseRegulation.actual
                    .q_search(params[:q])
    end
  end
end
