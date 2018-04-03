module Measures
  class AdditionalCodesController < ::Measures::BaseController

    def collection
      AdditionalCode.actual
                    .q_search(params[:q], params[:additional_code_type_id])
    end
  end
end

