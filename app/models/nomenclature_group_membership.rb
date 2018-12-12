class NomenclatureGroupMembership < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: %i[goods_nomenclature_sid
                                 goods_nomenclature_group_id
                                 goods_nomenclature_group_type
                                 goods_nomenclature_item_id
                                 validity_start_date]
  plugin :conformance_validator

  set_primary_key %i[goods_nomenclature_sid goods_nomenclature_group_id
                     goods_nomenclature_group_type goods_nomenclature_item_id
                     validity_start_date]

  def record_code
    "400".freeze
  end

  def subrecord_code
    "25".freeze
  end
end
