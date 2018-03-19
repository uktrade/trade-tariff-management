class MeasureTypesController < ApplicationController
  respond_to :json

  def index
    types = MeasureType.all
    json = []

    types.each do |type|

      json << {
        oid: type.oid,
        measure_type_id: type.measure_type_id,
        measure_type_series_id: type.measure_type_series_id,
        validity_start_date: type.validity_start_date,
        validity_end_date: type.validity_end_date,
        valid: false,
        measure_type_acronym: type.measure_type_acronym,
        description: type.description
      }
    end

    render json: json
  end
end
