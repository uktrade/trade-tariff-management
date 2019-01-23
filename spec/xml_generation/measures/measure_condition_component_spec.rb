require 'rails_helper'

describe "MeasureConditionComponent XML generation" do
  let(:db_record) do
    create(:measure_condition_component)
  end

  let(:data_namespace) do
    "oub:measure.condition.component"
  end

  let(:fields_to_check) do
    %i[
      measure_condition_sid
      duty_expression_id
      duty_amount
      monetary_unit_code
      measurement_unit_code
      measurement_unit_qualifier_code
    ]
  end

  include_context "xml_generation_record_context"
end
