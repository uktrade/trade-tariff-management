require 'rails_helper'

describe "QuotaOrderNumberOrigin XML generation" do
  let(:db_record) do
    create(:quota_order_number_origin, :xml)
  end

  let(:data_namespace) do
    "oub:quota.order.number.origin"
  end

  let(:fields_to_check) do
    %i[
      quota_order_number_origin_sid
      quota_order_number_sid
      geographical_area_id
      validity_start_date
      validity_end_date
      geographical_area_sid
    ]
  end

  include_context "xml_generation_record_context"
end
