require 'rails_helper'

describe "GoodsNomenclatureGroup XML generation" do
  let(:db_record) do
    create(:goods_nomenclature_group, :xml)
  end

  let(:data_namespace) do
    "oub:goods.nomenclature.group"
  end

  let(:fields_to_check) do
    %i[
      goods_nomenclature_group_type
      goods_nomenclature_group_id
      validity_start_date
      validity_end_date
      nomenclature_group_facility_code
    ]
  end

  include_context "xml_generation_record_context"
end
