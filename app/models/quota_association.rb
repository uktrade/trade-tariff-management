class QuotaAssociation < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: [:main_quota_definition_sid,
                               :sub_quota_definition_sid]
  plugin :conformance_validator

  set_primary_key [:main_quota_definition_sid, :sub_quota_definition_sid]

  def record_code
    "370".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
