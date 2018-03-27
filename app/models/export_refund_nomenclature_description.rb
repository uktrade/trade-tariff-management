class ExportRefundNomenclatureDescription < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :time_machine
  plugin :oplog, primary_key: :export_refund_nomenclature_period_sid
  plugin :conformance_validator

  set_primary_key [:export_refund_nomenclature_description_period_sid]

  def record_code
    "410".freeze
  end

  def subrecord_code
    "15".freeze
  end
end
