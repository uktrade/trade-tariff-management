require 'rails_helper'

describe "NomenclatureGroupMembership XML generation" do
  let(:db_record) do
    create(:nomenclature_group_membership, :xml)
  end

  let(:data_namespace) do
    "oub:nomenclature.group.membership"
  end

  let(:fields_to_check) do
    %i[
      goods_nomenclature_sid
      goods_nomenclature_group_type
      goods_nomenclature_group_id
      validity_start_date
      validity_end_date
      goods_nomenclature_item_id
      productline_suffix
    ]
  end

  include_context "xml_generation_record_context"
end
