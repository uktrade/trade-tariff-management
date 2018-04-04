class BaseController < ApplicationController

  respond_to :json

  expose(:json_list) do
    list = []

    collection.map do |record|
      list << record.json_mapping
    end

    list
  end

  def index
    render json: json_list, status: :ok
  end
end
