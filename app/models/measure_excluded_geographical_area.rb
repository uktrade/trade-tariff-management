class MeasureExcludedGeographicalArea < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: [:measure_sid, :geographical_area_sid]
  plugin :conformance_validator

  set_primary_key [:measure_sid, :geographical_area_sid]

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
end
