require 'rails_helper'

describe "MonetaryExchangeRate XML generation" do
  let(:db_record) do
    create(:monetary_exchange_rate)
  end

  let(:data_namespace) do
    "oub:monetary.exchange.rate"
  end

  let(:fields_to_check) do
    %i[
      monetary_exchange_period_sid
      child_monetary_unit_code
      exchange_rate
    ]
  end

  include_context "xml_generation_record_context"
end
