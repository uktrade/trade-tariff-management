class DutyExpressionsController < ApplicationController
  respond_to :json

  def index
    duties = DutyExpression.all
    json = []

    duties.each do |duty|

      json << {
        duty_expression_id: duty.duty_expression_id,
        abbreviation: duty.abbreviation,
        description: duty.description
      }
    end

    render json: json
  end
end
