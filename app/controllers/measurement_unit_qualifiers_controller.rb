class MeasurementUnitQualifiersController < ApplicationController
  respond_to :json

  def index
    qualifiers = MeasurementUnitQualifier.all
    json = []

    qualifiers.each do |qualifier|

      json << {
        measurement_unit_qualifier_code: qualifier.measurement_unit_qualifier_code,
        description: qualifier.description,
        abbreviation: qualifier.abbreviation
      }
    end

    render json: json
  end
end
