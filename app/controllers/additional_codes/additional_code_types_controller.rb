module AdditionalCodes
  class AdditionalCodeTypesController < ::BaseController

    def collection
      AdditionalCodeType.q_search(params[:q])
    end
  end
end
