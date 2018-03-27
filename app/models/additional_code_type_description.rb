class AdditionalCodeTypeDescription < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :additional_code_type_id
  plugin :conformance_validator

  set_primary_key [:additional_code_type_id]

  many_to_one :additional_code_type, key: :additional_code_type_id
  many_to_one :language

  def record_code
    "120".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
