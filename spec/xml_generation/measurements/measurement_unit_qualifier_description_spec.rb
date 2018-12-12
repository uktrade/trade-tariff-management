require 'rails_helper'

describe "MeasurementUnitQualifierDescription XML generation" do
  let(:db_record) do
    create(:measurement_unit_qualifier_description, :xml)
  end

  let(:data_namespace) do
    "oub:measurement.unit.qualifier.description"
  end

  let(:fields_to_check) do
    %i[
      measurement_unit_qualifier_code
      language_id
      description
    ]
  end

  include_context "xml_generation_record_context"
end
