module Measures
  class DutyExpressionsController < ::Measures::BaseController

    def collection
      DutyExpression.actual
    end
  end
end
