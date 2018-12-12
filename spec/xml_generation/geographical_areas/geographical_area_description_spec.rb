require 'rails_helper'

describe "GeographicalAreaDescription XML generation" do
  let(:db_record) do
    create(:geographical_area_description, :xml)
  end

  let(:data_namespace) do
    "oub:geographical.area.description"
  end

  let(:fields_to_check) do
    %i[
      geographical_area_description_period_sid
      language_id
      geographical_area_sid
      geographical_area_id
      description
    ]
  end

  include_context "xml_generation_record_context"
end
