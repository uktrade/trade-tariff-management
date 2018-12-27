module Measures
  class MonetaryUnitsController < ::BaseController
    def collection
      MonetaryUnit.q_search(params).eager(:monetary_unit_description).all
    end
  end
end
