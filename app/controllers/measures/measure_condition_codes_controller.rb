module Measures
  class MeasureConditionCodesController < ::BaseController

    def collection
      MeasureConditionCode.q_search(params)
    end
  end
end
