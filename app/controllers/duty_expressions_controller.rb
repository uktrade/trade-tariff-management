class DutyExpressionsController < ::BaseController

  def collection
    scope = DutyExpression.actual

    if params[:q].present?
      q_rule = params[:q].strip.downcase

      scope = scope.all.select do |duty_expression|
        ilike?(duty_expression.duty_expression_id, q_rule) ||
        ilike?(duty_expression.abbreviation, q_rule) ||
        ilike?(duty_expression.description, q_rule)
      end
    end

    scope.sort do |a, b|
      a.duty_expression_id <=> b.duty_expression_id
    end
  end
end
