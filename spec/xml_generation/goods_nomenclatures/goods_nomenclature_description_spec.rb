require 'rails_helper'

describe "GoodsNomenclatureDescription XML generation" do
  let(:db_record) do
    create(:goods_nomenclature_description, :xml)
  end

  let(:data_namespace) do
    "oub:goods.nomenclature.description"
  end

  let(:fields_to_check) do
    %i[
      goods_nomenclature_description_period_sid
      language_id
      goods_nomenclature_sid
      goods_nomenclature_item_id
      productline_suffix
      description
    ]
  end

  include_context "xml_generation_record_context"
end
