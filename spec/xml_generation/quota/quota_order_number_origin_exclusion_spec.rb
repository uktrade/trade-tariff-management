require 'rails_helper'

describe "QuotaOrderNumberOriginExclusion XML generation" do
  let(:db_record) do
    create(:quota_order_number_origin_exclusion)
  end

  let(:data_namespace) do
    "oub:quota.order.number.origin.exclusions"
  end

  let(:fields_to_check) do
    %i[
      quota_order_number_origin_sid
      excluded_geographical_area_sid
    ]
  end

  include_context "xml_generation_record_context"
end
