require 'rails_helper'

describe "MeasureTypeSeriesDescription XML generation" do
  let(:db_record) do
    create(:measure_type_series_description, :xml)
  end

  let(:data_namespace) do
    "oub:measure.type.series.description"
  end

  let(:fields_to_check) do
    %i[
      measure_type_series_id
      language_id
      description
    ]
  end

  include_context "xml_generation_record_context"
end
