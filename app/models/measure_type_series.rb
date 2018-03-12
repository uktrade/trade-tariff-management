class MeasureTypeSeries < Sequel::Model

  include ::XmlGeneration::BaseHelper

  set_primary_key [:measure_type_series_id]
  plugin :oplog, primary_key: :measure_type_series_id
  plugin :conformance_validator

  one_to_many :measure_types
end


