class QuotaUnblockingEvent < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: %i[oid quota_definition_sid]
  plugin :conformance_validator

  set_primary_key [:quota_definition_sid]

  def self.status
    'unblocked'
  end

  def record_code
    "375".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
