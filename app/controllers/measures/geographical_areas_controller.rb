module Measures
  class GeographicalAreasController < ::BaseController

    def collection
      GeographicalArea.conditional_search(params)
    end

    def check_multiple
      areas = {}

      params[:codes].each do |code|
        areas[code] = GeographicalArea.where(geographical_area_id: code).first.to_json
      end

      render json: areas
    end
  end
end
