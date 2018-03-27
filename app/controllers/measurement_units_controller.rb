class MeasurementUnitsController < ApplicationController
  respond_to :json

  def index
    units = MeasurementUnit.all
    json = []

    units.each do |unit|

      json << {
        measurement_unit_code: unit.measurement_unit_code,
        description: unit.description,
        abbreviation: unit.abbreviation
      }
    end

    render json: json
  end
end
