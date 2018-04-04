module AdditionalCodes
  class AdditionalCodeTypesController < ::BaseController

    def collection
      AdditionalCodeType.actual
                        .q_search(params[:q])
    end
  end
end
