class GoodsNomenclatureGroupDescription < Sequel::Model
  plugin :oplog, primary_key: [:goods_nomenclature_group_id,
                               :goods_nomenclature_group_type]
  plugin :conformance_validator

  set_primary_key [:goods_nomenclature_group_id, :goods_nomenclature_group_type]

  def record_code
    "270".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
