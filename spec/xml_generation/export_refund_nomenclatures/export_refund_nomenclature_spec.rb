require 'rails_helper'

describe "ExportRefundNomenclature XML generation" do

  let(:db_record) do
    create(:export_refund_nomenclature, :xml)
  end

  let(:data_namespace) do
    "oub:export.refund.nomenclature"
  end

  let(:fields_to_check) do
    [
      :export_refund_nomenclature_sid,
      :goods_nomenclature_item_id,
      :additional_code_type,
      :export_refund_code,
      :productline_suffix,
      :validity_start_date,
      :validity_end_date,
      :goods_nomenclature_sid
    ]
  end

  include_context "xml_generation_record_context"
end
