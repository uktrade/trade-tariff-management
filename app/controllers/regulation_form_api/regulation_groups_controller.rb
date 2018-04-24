module RegulationFormApi
  class RegulationGroupsController < ::BaseController

    def collection
      RegulationGroup.q_search(params[:q])
    end
  end
end
