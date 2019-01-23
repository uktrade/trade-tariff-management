require 'rails_helper'

describe "AdditionalCode XML generation" do
  let(:db_record) do
    create(:additional_code, :xml)
  end

  let(:data_namespace) do
    "oub:additional.code"
  end

  let(:fields_to_check) do
    %i[
      additional_code_sid
      additional_code_type_id
      additional_code
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
