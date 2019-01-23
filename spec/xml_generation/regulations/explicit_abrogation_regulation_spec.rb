require 'rails_helper'

describe "ExplicitAbrogationRegulation XML generation" do
  let(:db_record) do
    create(:explicit_abrogation_regulation, :xml)
  end

  let(:data_namespace) do
    "oub:explicit.abrogation.regulation"
  end

  let(:fields_to_check) do
    %i[
      explicit_abrogation_regulation_role
      explicit_abrogation_regulation_id
      published_date
      officialjournal_number
      officialjournal_page
      replacement_indicator
      abrogation_date
      information_text
    ]
  end

  include_context "xml_generation_record_context"
end
