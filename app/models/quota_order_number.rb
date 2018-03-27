class QuotaOrderNumber < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :time_machine
  plugin :oplog, primary_key: :quota_definition_sid
  plugin :conformance_validator

  set_primary_key [:quota_order_number_sid]

  one_to_one :quota_definition, key: :quota_order_number_id,
                                primary_key: :quota_order_number_id do |ds|
    ds.with_actual(QuotaDefinition)
  end

  one_to_one :quota_order_number_origin, primary_key: :quota_order_number_sid,
                                         key: :quota_order_number_sid

  delegate :present?, to: :quota_order_number_origin, prefix: true, allow_nil: true

  def record_code
    "360".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
