class DutyExpressionsController < ::BaseController

  def collection
    DutyExpression.q_search(params)
  end
end
