require 'rails_helper'

describe "FtsRegulationAction XML generation" do
  let(:db_record) do
    create(:fts_regulation_action)
  end

  let(:data_namespace) do
    "oub:fts.regulation.action"
  end

  let(:fields_to_check) do
    %i[
      fts_regulation_role
      fts_regulation_id
      stopped_regulation_role
      stopped_regulation_id
    ]
  end

  include_context "xml_generation_record_context"
end
