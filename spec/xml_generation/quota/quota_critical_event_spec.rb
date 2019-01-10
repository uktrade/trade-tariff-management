require 'rails_helper'

describe "QuotaCriticalEvent XML generation" do
  let(:db_record) do
    create(:quota_critical_event, :xml)
  end

  let(:data_namespace) do
    "oub:quota.critical.event"
  end

  let(:fields_to_check) do
    %i[
      quota_definition_sid
      occurrence_timestamp
      critical_state
      critical_state_change_date
    ]
  end

  include_context "xml_generation_record_context"
end
