module Measures
  class AdditionalCodeTypesController < ::Measures::BaseController

    def collection
      AdditionalCodeType.q_search(params[:q])
    end
  end
end

