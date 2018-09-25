class QuotaAssociation < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: [:main_quota_definition_sid,
                               :sub_quota_definition_sid]
  plugin :conformance_validator

  set_primary_key [:main_quota_definition_sid, :sub_quota_definition_sid]

  one_to_one :parent_quota, class: :QuotaOrderNumber,
                            key: :quota_order_number_sid,
                            primary_key: :main_quota_definition_sid

  one_to_one :sub_quota, class: :QuotaOrderNumber,
                         key: :quota_order_number_sid,
                         primary_key: :sub_quota_definition_sid

  def record_code
    "370".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
