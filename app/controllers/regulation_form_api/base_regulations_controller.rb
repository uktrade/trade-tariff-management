module RegulationFormApi
  class BaseRegulationsController < ::BaseController

    def collection
      BaseRegulation.actual
                    .not_replaced_and_partially_replaced
                    .q_search(params[:q])
    end
  end
end
