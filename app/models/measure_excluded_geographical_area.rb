class MeasureExcludedGeographicalArea < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: %i[measure_sid geographical_area_sid]
  plugin :conformance_validator

  set_primary_key %i[measure_sid geographical_area_sid]

  one_to_one :measure, key: :measure_sid,
                       primary_key: :measure_sid

  one_to_one :geographical_area, key: :geographical_area_sid,
                       primary_key: :geographical_area_sid

  def record_code
    "430".freeze
  end

  def subrecord_code
    "15".freeze
  end

  def to_json(_options = {})
    {
      geographical_area: geographical_area.to_json
    }
  end

  def validity_start_date
    geographical_area.membership_validity_start_date
  end

  def validity_end_date
    geographical_area.membership_validity_end_date
  end
end
