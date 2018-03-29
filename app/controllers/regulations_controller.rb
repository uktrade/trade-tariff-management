class RegulationsController < ApplicationController

  respond_to :json

  expose(:result) do
    list = []

    BaseRegulation.actual.map do |regulation|
      list << {
        regulation_id: regulation.base_regulation_id,
        description: "#{regulation.base_regulation_id}. #{regulation.information_text}"
      }
    end

    list
  end

  def index
    render json: result, status: :ok
  end
end
