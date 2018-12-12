require 'rails_helper'

describe "RegulationRoleType XML generation" do
  let(:db_record) do
    create(:regulation_role_type, :xml)
  end

  let(:data_namespace) do
    "oub:regulation.role.type"
  end

  let(:fields_to_check) do
    %i[
      regulation_role_type_id
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
