require 'rails_helper'

describe "MeasurementUnitQualifier XML generation" do
  let(:db_record) do
    create(:measurement_unit_qualifier, :xml)
  end

  let(:data_namespace) do
    "oub:measurement.unit.qualifier"
  end

  let(:fields_to_check) do
    %i[
      measurement_unit_qualifier_code
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
