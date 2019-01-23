require 'rails_helper'

describe "CompleteAbrogationRegulation XML generation" do
  let(:db_record) do
    create(:complete_abrogation_regulation, :xml)
  end

  let(:data_namespace) do
    "oub:complete.abrogation.regulation"
  end

  let(:fields_to_check) do
    %i[
      complete_abrogation_regulation_role
      complete_abrogation_regulation_id
      published_date
      officialjournal_number
      officialjournal_page
      replacement_indicator
      information_text
    ]
  end

  include_context "xml_generation_record_context"
end
