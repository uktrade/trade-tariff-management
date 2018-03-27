require 'rails_helper'

describe "ExportRefundNomenclatureDescription XML generation" do

  let(:db_record) do
    create(:export_refund_nomenclature_description, :xml)
  end

  let(:data_namespace) do
    "oub:export.refund.nomenclature.description"
  end

  let(:fields_to_check) do
    [
      :export_refund_nomenclature_description_period_sid,
      :language_id,
      :export_refund_nomenclature_sid,
      :goods_nomenclature_item_id,
      :additional_code_type,
      :export_refund_code,
      :productline_suffix,
      :description
    ]
  end

  include_context "xml_generation_record_context"
end
