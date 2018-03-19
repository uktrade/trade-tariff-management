class MeasureTypeSeriesController < ApplicationController
  respond_to :json

  def index
    json = []

    MeasureTypeSeries.all.each do |serie|
      json << {
        oid: serie.oid,
        measure_type_series_id: serie.measure_type_series_id,
        validity_start_date: serie.validity_start_date,
        validity_end_date: serie.validity_end_date,
        description: serie.description
      }
    end

    render json: json
  end
end
