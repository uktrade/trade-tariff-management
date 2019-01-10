require 'rails_helper'

describe "MeasurePartialTemporaryStop XML generation" do
  let(:db_record) do
    create(:measure_partial_temporary_stop, :xml)
  end

  let(:data_namespace) do
    "oub:measure.partial.temporary.stop"
  end

  let(:fields_to_check) do
    %i[
      measure_sid
      partial_temporary_stop_regulation_id
      partial_temporary_stop_regulation_officialjournal_number
      partial_temporary_stop_regulation_officialjournal_page
      abrogation_regulation_id
      abrogation_regulation_officialjournal_number
      abrogation_regulation_officialjournal_page
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
