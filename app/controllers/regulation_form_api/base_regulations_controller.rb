module RegulationFormApi
  class BaseRegulationsController < ::BaseController
    def collection
      ::BaseOrModificationRegulationSearch.new(params[:q]).result
    end
  end
end
