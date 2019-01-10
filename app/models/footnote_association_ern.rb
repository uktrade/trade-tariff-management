class FootnoteAssociationErn < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: %i[export_refund_nomenclature_sid
                                 footnote_id
                                 footnote_type
                                 validity_start_date]
  plugin :conformance_validator

  set_primary_key %i[export_refund_nomenclature_sid footnote_id footnote_type
                     validity_start_date]

  def record_code
    "410".freeze
  end

  def subrecord_code
    "20".freeze
  end
end
