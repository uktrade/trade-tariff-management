class Language < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :language_id
  plugin :conformance_validator

  set_primary_key [:language_id]

  def record_code
    "130".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
