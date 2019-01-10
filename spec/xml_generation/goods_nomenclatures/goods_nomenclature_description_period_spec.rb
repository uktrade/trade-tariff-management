require 'rails_helper'

describe "GoodsNomenclatureDescriptionPeriod XML generation" do
  let(:db_record) do
    create(:goods_nomenclature_description_period, :xml)
  end

  let(:data_namespace) do
    "oub:goods.nomenclature.description.period"
  end

  let(:fields_to_check) do
    %i[
      goods_nomenclature_description_period_sid
      goods_nomenclature_sid
      validity_start_date
      goods_nomenclature_item_id
      productline_suffix
    ]
  end

  include_context "xml_generation_record_context"
end
