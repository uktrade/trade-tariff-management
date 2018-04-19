module RegulationFormApi
  class CompleteAbrogationRegulationsController < ::BaseController

    def collection
      CompleteAbrogationRegulation.q_search(:complete_abrogation_regulation_id, params[:q]))
    end
  end
end
