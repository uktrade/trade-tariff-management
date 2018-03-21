require 'rails_helper'

describe "CertificateDescriptionPeriod XML generation" do

  let(:db_record) do
    create(:certificate_description_period, :xml)
  end

  let(:data_namespace) do
    "oub:certificate.description.period"
  end

  let(:fields_to_check) do
    [
      :certificate_description_period_sid,
      :certificate_type_code,
      :certificate_code,
      :validity_start_date,
      :validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
