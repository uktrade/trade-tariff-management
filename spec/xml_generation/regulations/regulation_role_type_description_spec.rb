require 'rails_helper'

describe "RegulationRoleTypeDescription XML generation" do
  let(:db_record) do
    create(:regulation_role_type_description, :xml)
  end

  let(:data_namespace) do
    "oub:regulation.role.type.description"
  end

  let(:fields_to_check) do
    %i[
      regulation_role_type_id
      language_id
      description
    ]
  end

  include_context "xml_generation_record_context"
end
