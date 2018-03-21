require 'rails_helper'

describe "ExportRefundNomenclatureDescriptionPeriod XML generation" do

  let(:db_record) do
    create(:export_refund_nomenclature_description_period, :xml)
  end

  let(:data_namespace) do
    "oub:export.refund.nomenclature.description.period"
  end

  let(:fields_to_check) do
    [
      :export_refund_nomenclature_description_period_sid,
      :export_refund_nomenclature_sid,
      :validity_start_date,
      :goods_nomenclature_item_id,
      :additional_code_type,
      :export_refund_code,
      :productline_suffix,
      :validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
