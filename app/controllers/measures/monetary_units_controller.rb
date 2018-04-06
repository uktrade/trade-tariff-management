module Measures
  class MonetaryUnitsController < ::BaseController

    def collection
      MonetaryUnit.actual
    end
  end
end
