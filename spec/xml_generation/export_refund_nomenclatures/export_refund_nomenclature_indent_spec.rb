require 'rails_helper'

describe "ExportRefundNomenclatureIndent XML generation" do

  let(:db_record) do
    create(:export_refund_nomenclature_indent, :xml)
  end

  let(:data_namespace) do
    "oub:export.refund.nomenclature.indents"
  end

  let(:fields_to_check) do
    [
      :export_refund_nomenclature_indents_sid,
      :export_refund_nomenclature_sid,
      :validity_start_date,
      :number_export_refund_nomenclature_indents,
      :goods_nomenclature_item_id,
      :additional_code_type,
      :export_refund_code,
      :productline_suffix,
      :validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
