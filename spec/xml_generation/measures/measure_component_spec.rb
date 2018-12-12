require 'rails_helper'

describe "MeasureComponent XML generation" do
  let(:db_record) do
    create(:measure_component)
  end

  let(:data_namespace) do
    "oub:measure.component"
  end

  let(:fields_to_check) do
    %i[
      measure_sid
      duty_expression_id
      duty_amount
      monetary_unit_code
      measurement_unit_code
      measurement_unit_qualifier_code
    ]
  end

  include_context "xml_generation_record_context"
end
