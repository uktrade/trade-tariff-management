class MeasureConditionCodesController < ApplicationController
  respond_to :json

  def index
    codes = MeasureConditionCode.all
    json = []

    codes.each do |code|

      json << {
        condition_code: code.condition_code,
        valid: false,
        description: code.description
      }
    end

    render json: json
  end
end
