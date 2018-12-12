require 'rails_helper'

describe "GoodsNomenclatureSuccessor XML generation" do
  let(:db_record) do
    create(:goods_nomenclature_successor)
  end

  let(:data_namespace) do
    "oub:goods.nomenclature.successor"
  end

  let(:fields_to_check) do
    %i[
      goods_nomenclature_sid
      absorbed_goods_nomenclature_item_id
      absorbed_productline_suffix
      goods_nomenclature_item_id
      productline_suffix
    ]
  end

  include_context "xml_generation_record_context"
end
