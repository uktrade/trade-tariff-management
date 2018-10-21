class FootnoteAssociationGoodsNomenclature < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :time_machine
  plugin :oplog, primary_key: [:footnote_id,
                               :footnote_type,
                               :goods_nomenclature_sid]
  plugin :conformance_validator

  set_primary_key [:footnote_id, :footnote_type, :goods_nomenclature_sid]

  def record_code
    "400".freeze
  end

  def subrecord_code
    "20".freeze
  end
end
