module Measures
  class GeographicalAreasController < ::BaseController

    def collection
      GeographicalArea.conditional_search(params)
    end
  end
end
