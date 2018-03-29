module Measures
  class AdditionalCodesController < ::Measures::BaseController

    def collection
      AdditionalCode.actual
                    .q_search(params[:q])
    end
  end
end

