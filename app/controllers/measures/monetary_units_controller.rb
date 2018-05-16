module Measures
  class MonetaryUnitsController < ::BaseController

    def collection
      MonetaryUnit.q_search(params)
    end
  end
end
