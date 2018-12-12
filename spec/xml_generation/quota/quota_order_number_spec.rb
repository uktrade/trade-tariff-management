require 'rails_helper'

describe "QuotaOrderNumber XML generation" do
  let(:db_record) do
    create(:quota_order_number, :xml)
  end

  let(:data_namespace) do
    "oub:quota.order.number"
  end

  let(:fields_to_check) do
    %i[
      quota_order_number_sid
      quota_order_number_id
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
