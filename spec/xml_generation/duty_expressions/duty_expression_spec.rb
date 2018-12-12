require 'rails_helper'

describe "DutyExpression XML generation" do
  let(:db_record) do
    create(:duty_expression, :xml)
  end

  let(:data_namespace) do
    "oub:duty.expression"
  end

  let(:fields_to_check) do
    %i[
      duty_expression_id
      validity_start_date
      validity_end_date
      duty_amount_applicability_code
      measurement_unit_applicability_code
      monetary_unit_applicability_code
    ]
  end

  include_context "xml_generation_record_context"
end
