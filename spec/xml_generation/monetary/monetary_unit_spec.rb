require 'rails_helper'

describe "MonetaryUnit XML generation" do
  let(:db_record) do
    create(:monetary_unit, :xml)
  end

  let(:data_namespace) do
    "oub:monetary.unit"
  end

  let(:fields_to_check) do
    %i[
      monetary_unit_code
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
