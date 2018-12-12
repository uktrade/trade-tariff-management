require 'rails_helper'

describe "ProrogationRegulation XML generation" do
  let(:db_record) do
    create(:prorogation_regulation, :xml)
  end

  let(:data_namespace) do
    "oub:prorogation.regulation"
  end

  let(:fields_to_check) do
    %i[
      prorogation_regulation_role
      prorogation_regulation_id
      published_date
      officialjournal_number
      officialjournal_page
      replacement_indicator
      information_text
    ]
  end

  include_context "xml_generation_record_context"
end
