require 'rails_helper'

describe "MeursingAdditionalCode XML generation" do
  let(:db_record) do
    create(:meursing_additional_code, :xml)
  end

  let(:data_namespace) do
    "oub:meursing.additional.code"
  end

  let(:fields_to_check) do
    %i[
      meursing_additional_code_sid
      additional_code
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
