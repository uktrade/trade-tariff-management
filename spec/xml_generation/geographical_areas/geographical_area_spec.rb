require 'rails_helper'

describe "GeographicalArea XML generation" do
  let(:db_record) do
    create(:geographical_area, :xml)
  end

  let(:data_namespace) do
    "oub:geographical.area"
  end

  let(:fields_to_check) do
    %i[
      geographical_area_sid
      parent_geographical_area_group_sid
      validity_start_date
      validity_end_date
      geographical_code
      geographical_area_id
    ]
  end

  include_context "xml_generation_record_context"
end
