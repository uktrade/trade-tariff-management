require 'rails_helper'

describe "AdditionalCodeTypeMeasureType XML generation" do
  let(:db_record) do
    create(:additional_code_type_measure_type, :xml)
  end

  let(:data_namespace) do
    "oub:additional.code.type.measure.type"
  end

  let(:fields_to_check) do
    %i[
      measure_type_id
      additional_code_type_id
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
