class QuotaOrderNumberOriginExclusion < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: [:quota_order_number_origin_sid,
                               :excluded_geographical_area_sid]
  plugin :conformance_validator

  set_primary_key [:quota_order_number_origin_sid, :excluded_geographical_area_sid]

  def record_code
    "360".freeze
  end

  def subrecord_code
    "15".freeze
  end
end
