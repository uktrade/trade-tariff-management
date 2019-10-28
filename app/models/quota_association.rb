class QuotaAssociation < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: %i[main_quota_definition_sid
                                 sub_quota_definition_sid]
  plugin :conformance_validator

  set_primary_key %i[main_quota_definition_sid sub_quota_definition_sid]

  many_to_one :main_quota_definition,
              key: :main_quota_definition_sid,
              class: QuotaDefinition

  many_to_one :sub_quota_definition,
              key: :sub_quota_definition_sid,
              class: QuotaDefinition

  def record_code
    "370".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
