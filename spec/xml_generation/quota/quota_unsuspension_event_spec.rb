require 'rails_helper'

describe "QuotaUnsuspensionEvent XML generation" do
  let(:db_record) do
    create(:quota_unsuspension_event)
  end

  let(:data_namespace) do
    "oub:quota.unsuspension.event"
  end

  let(:fields_to_check) do
    %i[
      quota_definition_sid
      occurrence_timestamp
      unsuspension_date
    ]
  end

  include_context "xml_generation_record_context"
end
