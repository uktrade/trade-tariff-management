require 'rails_helper'

describe "MeasureTypeDescription XML generation" do

  let(:db_record) do
    create(:measure_type_description, :xml)
  end

  let(:data_namespace) do
    "oub:measure.type.description"
  end

  let(:fields_to_check) do
    [
      :measure_type_id,
      :language_id,
      :description
    ]
  end

  include_context "xml_generation_record_context"
end
