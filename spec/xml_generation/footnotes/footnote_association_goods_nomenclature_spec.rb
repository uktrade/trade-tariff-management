require 'rails_helper'

describe "FootnoteAssociationGoodsNomenclature XML generation" do
  let(:db_record) do
    create(:footnote_association_goods_nomenclature, :xml)
  end

  let(:data_namespace) do
    "oub:footnote.association.goods.nomenclature"
  end

  let(:fields_to_check) do
    %i[
      goods_nomenclature_sid
      footnote_type
      footnote_id
      goods_nomenclature_item_id
      productline_suffix
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
