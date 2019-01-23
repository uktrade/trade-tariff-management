module RegulationFormApi
  class RegulationGroupsController < ::BaseController
    def collection
      RegulationGroup.actual
                     .q_search(params[:q])
    end
  end
end
