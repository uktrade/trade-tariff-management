require 'rails_helper'

describe "RegulationGroup XML generation" do

  let(:db_record) do
    create(:regulation_group, :xml)
  end

  let(:data_namespace) do
    "oub:regulation.group"
  end

  let(:fields_to_check) do
    [
      :regulation_group_id,
      :validity_start_date,
      :validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
