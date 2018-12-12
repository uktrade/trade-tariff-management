require 'rails_helper'

describe "GoodsNomenclatureIndent XML generation" do
  let(:db_record) do
    create(:goods_nomenclature_indent, :xml)
  end

  let(:data_namespace) do
    "oub:goods.nomenclature.indents"
  end

  let(:fields_to_check) do
    %i[
      goods_nomenclature_indent_sid
      goods_nomenclature_sid
      validity_start_date
      number_indents
      goods_nomenclature_item_id
      productline_suffix
    ]
  end

  include_context "xml_generation_record_context"
end
