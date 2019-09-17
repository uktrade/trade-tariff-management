class FootnoteAssociationGoodsNomenclature < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :time_machine
  plugin :oplog, primary_key: %i[footnote_id
                                 footnote_type
                                 goods_nomenclature_sid]
  plugin :conformance_validator

  set_primary_key %i[footnote_id footnote_type goods_nomenclature_sid]

  def record_code
    "400".freeze
  end

  def subrecord_code
    "20".freeze
  end

  dataset_module do
    def current
      where("validity_end_date > :date or validity_end_date is NULL", date: Date.today)
    end
  end
end
