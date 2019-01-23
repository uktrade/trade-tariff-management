class TransmissionComment < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: %i[comment_sid language_id]
  plugin :conformance_validator

  set_primary_key %i[comment_sid language_id]

  many_to_one :language

  def record_code
    "01".freeze
  end

  def subrecord_code
    "000".freeze
  end
end
