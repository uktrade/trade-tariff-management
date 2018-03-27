require 'rails_helper'

describe "CertificateType XML generation" do

  let(:db_record) do
    create(:certificate_type, :xml)
  end

  let(:data_namespace) do
    "oub:certificate.type"
  end

  let(:fields_to_check) do
    [
      :certificate_type_code,
      :validity_start_date,
      :validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
