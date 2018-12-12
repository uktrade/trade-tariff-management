class MonetaryExchangePeriod < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: %i[monetary_exchange_period_sid
                                 parent_monetary_unit_code]
  plugin :conformance_validator

  set_primary_key %i[monetary_exchange_period_sid parent_monetary_unit_code]

  def record_code
    "440".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
