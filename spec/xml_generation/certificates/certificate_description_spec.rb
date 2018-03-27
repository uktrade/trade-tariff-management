require 'rails_helper'

describe "CertificateDescription XML generation" do

  let(:db_record) do
    create(:certificate_description, :xml)
  end

  let(:data_namespace) do
    "oub:certificate.description"
  end

  let(:fields_to_check) do
    [
      :certificate_description_period_sid,
      :language_id,
      :certificate_type_code,
      :certificate_code,
      :description
    ]
  end

  include_context "xml_generation_record_context"
end
