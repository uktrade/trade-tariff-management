class QuotaOrderNumberOrigin < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association
  include OwnValidityPeriod

  plugin :oplog, primary_key: :quota_order_number_origin_sid
  plugin :conformance_validator

  set_primary_key [:quota_order_number_origin_sid]

  one_to_one :geographical_area, primary_key: :geographical_area_sid,
                                         key: :geographical_area_sid
  one_to_one :quota_order_number, primary_key: :quota_order_number_sid,
                                  key: :quota_order_number_sid
  one_to_many :quota_order_number_origin_exclusions,
              primary_key: :quota_order_number_origin_sid,
              key: :quota_order_number_origin_sid

  def record_code
    "360".freeze
  end

  def subrecord_code
    "10".freeze
  end
end
