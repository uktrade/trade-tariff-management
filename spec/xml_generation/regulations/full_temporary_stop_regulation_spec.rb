require 'rails_helper'

describe "FullTemporaryStopRegulation XML generation" do
  let(:db_record) do
    create(:fts_regulation, :xml)
  end

  let(:data_namespace) do
    "oub:full.temporary.stop.regulation"
  end

  let(:fields_to_check) do
    %i[
      full_temporary_stop_regulation_role
      full_temporary_stop_regulation_id
      published_date
      officialjournal_number
      officialjournal_page
      explicit_abrogation_regulation_role
      explicit_abrogation_regulation_id
      replacement_indicator
      information_text
      effective_enddate
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
