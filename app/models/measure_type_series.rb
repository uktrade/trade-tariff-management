class MeasureTypeSeries < Sequel::Model
  set_primary_key [:measure_type_series_id]
  plugin :oplog, primary_key: :measure_type_series_id
  plugin :conformance_validator

  one_to_many :measure_types

  def record_code
    "140".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
