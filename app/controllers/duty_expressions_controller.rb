class DutyExpressionsController < ::BaseController

  def collection
    DutyExpression.actual
  end
end
