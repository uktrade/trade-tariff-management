require 'rails_helper'

describe "MeasureConditionCodeDescription XML generation" do
  let(:db_record) do
    create(:measure_condition_code_description, :xml)
  end

  let(:data_namespace) do
    "oub:measure.condition.code.description"
  end

  let(:fields_to_check) do
    %i[
      condition_code
      language_id
      description
    ]
  end

  include_context "xml_generation_record_context"
end
