class MeasureActionesController < ApplicationController
  respond_to :json

  def index
    actions = MeasureAction.all
    json = []

    actions.each do |action|

      json << {
        action_code: action.action_code,
        description: action.description
      }
    end

    render json: json
  end
end
