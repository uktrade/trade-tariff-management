require 'rails_helper'

describe "QuotaExhaustionEvent XML generation" do
  let(:db_record) do
    create(:quota_exhaustion_event)
  end

  let(:data_namespace) do
    "oub:quota.exhaustion.event"
  end

  let(:fields_to_check) do
    %i[
      quota_definition_sid
      occurrence_timestamp
      exhaustion_date
    ]
  end

  include_context "xml_generation_record_context"
end
