module Measures
  class AdditionalCodeTypesController < ::Measures::BaseController

    def collection
      AdditionalCodeType.actual.q_search(params[:q])
    end
  end
end
