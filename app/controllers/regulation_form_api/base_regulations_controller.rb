module RegulationFormApi
  class BaseRegulationsController < ::BaseController

    def collection
      BaseRegulation.q_search(:base_regulation_id, params[:q]))
    end
  end
end
