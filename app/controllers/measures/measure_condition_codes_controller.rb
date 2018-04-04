module Measures
  class MeasureConditionCodesController < ::BaseController

    def collection
      MeasureConditionCode.actual
    end
  end
end
