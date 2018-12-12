require 'rails_helper'

describe "MonetaryExchangePeriod XML generation" do
  let(:db_record) do
    create(:monetary_exchange_period, :xml)
  end

  let(:data_namespace) do
    "oub:monetary.exchange.period"
  end

  let(:fields_to_check) do
    %i[
      monetary_exchange_period_sid
      parent_monetary_unit_code
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
