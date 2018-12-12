require 'rails_helper'

describe "MeasureTypeSeries XML generation" do
  let(:db_record) do
    create(:measure_type_series, :xml)
  end

  let(:data_namespace) do
    "oub:measure.type.series"
  end

  let(:fields_to_check) do
    %i[
      measure_type_series_id
      measure_type_combination
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
