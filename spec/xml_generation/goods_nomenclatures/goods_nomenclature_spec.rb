require 'rails_helper'

describe "GoodsNomenclature XML generation" do
  let(:db_record) do
    create(:goods_nomenclature, :xml)
  end

  let(:data_namespace) do
    "oub:goods.nomenclature"
  end

  let(:fields_to_check) do
    %i[
      goods_nomenclature_sid
      goods_nomenclature_item_id
      producline_suffix
      validity_start_date
      validity_end_date
      statistical_indicator
    ]
  end

  include_context "xml_generation_record_context"
end
