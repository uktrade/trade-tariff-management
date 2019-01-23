require 'rails_helper'

describe "GeographicalAreaDescriptionPeriod XML generation" do
  let(:db_record) do
    create(:geographical_area_description_period, :xml)
  end

  let(:data_namespace) do
    "oub:geographical.area.description.period"
  end

  let(:fields_to_check) do
    %i[
      geographical_area_description_period_sid
      geographical_area_sid
      validity_start_date
      geographical_area_id
    ]
  end

  include_context "xml_generation_record_context"
end
