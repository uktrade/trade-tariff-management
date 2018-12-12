require 'rails_helper'

describe "MeasureCondition XML generation" do
  let(:db_record) do
    create(:measure_condition)
  end

  let(:data_namespace) do
    "oub:measure.condition"
  end

  let(:fields_to_check) do
    %i[
      measure_condition_sid
      measure_sid
      condition_code
      component_sequence_number
      condition_duty_amount
      condition_monetary_unit_code
      condition_measurement_unit_code
      condition_measurement_unit_qualifier_code
      action_code
      certificate_type_code
      certificate_code
    ]
  end

  include_context "xml_generation_record_context"
end
