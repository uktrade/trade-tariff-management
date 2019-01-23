require 'rails_helper'

describe "MeasureAction XML generation" do
  let(:db_record) do
    create(:measure_action, :xml)
  end

  let(:data_namespace) do
    "oub:measure.action"
  end

  let(:fields_to_check) do
    %i[
      action_code
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
