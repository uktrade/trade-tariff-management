require 'rails_helper'

describe "CertificateTypeDescription XML generation" do

  let(:db_record) do
    create(:certificate_type_description, :xml)
  end

  let(:data_namespace) do
    "oub:certificate.type.description"
  end

  let(:fields_to_check) do
    [
      :certificate_type_code,
      :language_id,
      :description
    ]
  end

  include_context "xml_generation_record_context"
end
