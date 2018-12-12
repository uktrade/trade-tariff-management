require 'rails_helper'

describe "GoodsNomenclatureOrigin XML generation" do
  let(:db_record) do
    create(:goods_nomenclature_origin)
  end

  let(:data_namespace) do
    "oub:goods.nomenclature.origin"
  end

  let(:fields_to_check) do
    %i[
      goods_nomenclature_sid
      derived_goods_nomenclature_item_id
      derived_productline_suffix
      goods_nomenclature_item_id
      productline_suffix
    ]
  end

  include_context "xml_generation_record_context"
end
