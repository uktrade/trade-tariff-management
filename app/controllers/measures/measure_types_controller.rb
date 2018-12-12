module Measures
  class MeasureTypesController < ::BaseController
    def collection
      MeasureType.q_search(params)
    end
  end
end
