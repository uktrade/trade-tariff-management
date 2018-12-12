class GoodsNomenclatureGroup < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: %i[goods_nomenclature_group_id
                                 goods_nomenclature_group_type]
  plugin :conformance_validator

  set_primary_key %i[goods_nomenclature_group_id goods_nomenclature_group_type]

  def record_code
    "270".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
