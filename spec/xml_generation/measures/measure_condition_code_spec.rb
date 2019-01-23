require 'rails_helper'

describe "MeasureConditionCode XML generation" do
  let(:db_record) do
    create(:measure_condition_code, :xml)
  end

  let(:data_namespace) do
    "oub:measure.condition.code"
  end

  let(:fields_to_check) do
    %i[
      condition_code
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
