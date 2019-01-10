require 'rails_helper'

describe "Measurement XML generation" do
  let(:db_record) do
    create(:measurement, :xml)
  end

  let(:data_namespace) do
    "oub:measurement"
  end

  let(:fields_to_check) do
    %i[
      measurement_unit_code
      measurement_unit_qualifier_code
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
