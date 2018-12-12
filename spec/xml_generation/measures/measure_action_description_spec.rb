require 'rails_helper'

describe "MeasureActionDescription XML generation" do
  let(:db_record) do
    create(:measure_action_description, :xml)
  end

  let(:data_namespace) do
    "oub:measure.action.description"
  end

  let(:fields_to_check) do
    %i[
      action_code
      language_id
      description
    ]
  end

  include_context "xml_generation_record_context"
end
