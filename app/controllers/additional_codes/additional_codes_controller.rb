module AdditionalCodes
  class AdditionalCodesController < ::BaseController

    def collection
      AdditionalCode.q_search(params)
    end
  end
end
