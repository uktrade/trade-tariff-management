require 'rails_helper'

describe "QuotaBalanceEvent XML generation" do
  let(:db_record) do
    create(:quota_balance_event)
  end

  let(:data_namespace) do
    "oub:quota.balance.event"
  end

  let(:fields_to_check) do
    %i[
      quota_definition_sid
      occurrence_timestamp
      last_import_date_in_allocation
      old_balance
      new_balance
      imported_amount
    ]
  end

  include_context "xml_generation_record_context"
end
