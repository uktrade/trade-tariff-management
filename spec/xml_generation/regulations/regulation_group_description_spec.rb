require 'rails_helper'

describe "RegulationGroupDescription XML generation" do

  let(:db_record) do
    create(:regulation_group_description)
  end

  let(:data_namespace) do
    "oub:regulation.group.description"
  end

  let(:fields_to_check) do
    [
      :regulation_group_id,
      :language_id,
      :description
    ]
  end

  include_context "xml_generation_record_context"
end
