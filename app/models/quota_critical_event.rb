class QuotaCriticalEvent < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: %i[quota_definition_sid occurrence_timestamp]
  plugin :conformance_validator

  set_primary_key %i[quota_definition_sid occurrence_timestamp]

  many_to_one :quota_definition, key: :quota_definition_sid,
                                 primary_key: :quota_definition_sid

  def self.status
    'critical'
  end

  def record_code
    "375".freeze
  end

  def subrecord_code
    "10".freeze
  end
end
