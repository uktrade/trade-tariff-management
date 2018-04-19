module RegulationFormApi
  class CompleteAbrogationRegulationsController < ::BaseController

    def collection
      CompleteAbrogationRegulation.actual
                                  .q_search(params[:q])
    end
  end
end
