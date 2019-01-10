require 'rails_helper'

describe "GoodsNomenclatureGroupDescription XML generation" do
  let(:db_record) do
    create(:goods_nomenclature_group_description, :xml)
  end

  let(:data_namespace) do
    "oub:goods.nomenclature.group.description"
  end

  let(:fields_to_check) do
    %i[
      goods_nomenclature_group_type
      goods_nomenclature_group_id
      language_id
      description
    ]
  end

  include_context "xml_generation_record_context"
end
