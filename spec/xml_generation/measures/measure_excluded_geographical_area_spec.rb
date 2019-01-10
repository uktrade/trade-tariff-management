require 'rails_helper'

describe "MeasureExcludedGeographicalArea XML generation" do
  let(:db_record) do
    create(:measure_excluded_geographical_area)
  end

  let(:data_namespace) do
    "oub:measure.excluded.geographical.area"
  end

  let(:fields_to_check) do
    %i[
      measure_sid
      excluded_geographical_area
      geographical_area_sid
    ]
  end

  include_context "xml_generation_record_context"
end
