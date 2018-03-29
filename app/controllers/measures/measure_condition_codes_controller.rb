module Measures
  class MeasureConditionCodesController < ::Measures::BaseController

    def collection
      MeasureConditionCode.actual
    end
  end
end
