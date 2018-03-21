class LanguageDescription < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: [:language_id, :language_code_id]
  plugin :conformance_validator

  set_primary_key  [:language_id, :language_code_id]

  def record_code
    "130".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
