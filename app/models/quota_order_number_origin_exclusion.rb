class QuotaOrderNumberOriginExclusion < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: %i[quota_order_number_origin_sid
                                 excluded_geographical_area_sid]
  plugin :conformance_validator

  set_primary_key %i[quota_order_number_origin_sid excluded_geographical_area_sid]

  one_to_one :geographical_area,
             key: :geographical_area_sid,
             primary_key: :excluded_geographical_area_sid

  delegate :geographical_area_id, to: :geographical_area, allow_nil: true

  def record_code
    "360".freeze
  end

  def subrecord_code
    "15".freeze
  end
end
