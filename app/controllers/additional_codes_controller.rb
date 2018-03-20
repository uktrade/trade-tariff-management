class AdditionalCodesController < ApplicationController
  respond_to :json

  def index
    codes = AdditionalCode.where(additional_code: params[:q])
    json = []

    codes.each do |code|

      json << {
        additional_code: code.additional_code,
        description: code.description
      }
    end

    render json: json
  end
end
