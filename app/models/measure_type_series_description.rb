class MeasureTypeSeriesDescription < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :measure_type_series_id
  plugin :conformance_validator

  set_primary_key [:measure_type_series_id]

  def record_code
    "140".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
