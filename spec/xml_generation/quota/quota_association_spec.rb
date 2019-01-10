require 'rails_helper'

describe "QuotaAssociation XML generation" do
  let(:db_record) do
    create(:quota_association)
  end

  let(:data_namespace) do
    "oub:quota.association"
  end

  let(:fields_to_check) do
    %i[
      main_quota_definition_sid
      sub_quota_definition_sid
      relation_type
      coefficient
    ]
  end

  include_context "xml_generation_record_context"
end
