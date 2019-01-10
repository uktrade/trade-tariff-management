module Measures
  class MeasureConditionCodesController < ::BaseController
    def collection
      MeasureConditionCode.q_search(params).eager(:measure_condition_code_description).all
    end
  end
end
