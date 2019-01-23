require 'rails_helper'

describe "Measure XML generation" do
  let(:db_record) do
    create(:measure, :xml)
  end

  let(:data_namespace) do
    "oub:measure"
  end

  let(:fields_to_check) do
    [
      :measure_sid,
      { measure_type_id: :measure_type },
      :validity_start_date,
      :validity_end_date,
      :geographical_area_sid,
      { geographical_area_id: :geographical_area },
      :goods_nomenclature_item_id,
      :goods_nomenclature_sid,
      :additional_code_sid,
      { additional_code_id: :additional_code },
      { additional_code_type_id: :additional_code_type },
      :measure_generating_regulation_role,
      :measure_generating_regulation_id,
      :justification_regulation_role,
      :justification_regulation_id,
      :export_refund_nomenclature_sid,
      :ordernumber,
      :reduction_indicator
    ]
  end

  include_context "xml_generation_record_context"
end
