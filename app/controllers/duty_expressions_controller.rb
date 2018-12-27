class DutyExpressionsController < ::BaseController
  def collection
    scope = DutyExpression.actual.eager(:duty_expression_description).all

    if params[:q].present?
      q_rule = params[:q].strip.downcase

      scope = scope.select do |duty_expression|
        ilike?(duty_expression.duty_expression_id, q_rule) ||
          ilike?(duty_expression.abbreviation, q_rule) ||
          ilike?(duty_expression.description, q_rule)
      end
    end

    scope.sort_by(&:duty_expression_id)
  end
end
