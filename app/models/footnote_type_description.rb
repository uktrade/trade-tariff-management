class FootnoteTypeDescription < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :footnote_type_id
  plugin :conformance_validator

  set_primary_key [:footnote_type_id]

  def record_code
    "100".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
