module RegulationFormApi
  class ExplicitAbrogationRegulationsController < ::BaseController

    def collection
      ExplicitAbrogationRegulation.actual
                                  .q_search(params[:q])
    end
  end
end
