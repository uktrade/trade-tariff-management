require 'rails_helper'

describe "QuotaReopeningEvent XML generation" do
  let(:db_record) do
    create(:quota_reopening_event)
  end

  let(:data_namespace) do
    "oub:quota.reopening.event"
  end

  let(:fields_to_check) do
    %i[
      quota_definition_sid
      occurrence_timestamp
      reopening_date
    ]
  end

  include_context "xml_generation_record_context"
end
