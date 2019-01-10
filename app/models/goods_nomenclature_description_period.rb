class GoodsNomenclatureDescriptionPeriod < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :time_machine
  plugin :oplog, primary_key: :geographical_area_description_period_sid
  plugin :conformance_validator

  set_primary_key [:goods_nomenclature_description_period_sid]

  many_to_one :goods_nomenclature, key: :goods_nomenclature_sid
  many_to_one :goods_nomenclature_description, key: %i[goods_nomenclature_sid
                                                       goods_nomenclature_description_period_sid]

  def record_code
    "400".freeze
  end

  def subrecord_code
    "10".freeze
  end
end
