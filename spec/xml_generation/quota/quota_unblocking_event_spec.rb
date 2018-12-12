require 'rails_helper'

describe "QuotaUnblockingEvent XML generation" do
  let(:db_record) do
    create(:quota_unblocking_event)
  end

  let(:data_namespace) do
    "oub:quota.unblocking.event"
  end

  let(:fields_to_check) do
    %i[
      quota_definition_sid
      occurrence_timestamp
      unblocking_date
    ]
  end

  include_context "xml_generation_record_context"
end
