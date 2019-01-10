require 'rails_helper'

describe "MeasureType XML generation" do
  let(:db_record) do
    create(:measure_type, :xml)
  end

  let(:data_namespace) do
    "oub:measure.type"
  end

  let(:fields_to_check) do
    %i[
      measure_type_id
      validity_start_date
      validity_end_date
      trade_movement_code
      priority_code
      measure_component_applicable_code
      origin_dest_code
      order_number_capture_code
      measure_explosion_level
      measure_type_series_id
    ]
  end

  include_context "xml_generation_record_context"
end
