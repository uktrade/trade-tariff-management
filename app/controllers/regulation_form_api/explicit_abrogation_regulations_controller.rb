module RegulationFormApi
  class ExplicitAbrogationRegulationsController < ::BaseController

    def collection
      ExplicitAbrogationRegulation.q_search(:explicit_abrogation_regulation_id, params[:q]))
    end
  end
end
