class MeasurementUnitDescription < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :measurement_unit_code
  plugin :conformance_validator

  set_primary_key [:measurement_unit_code]

  def record_code
    "210".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
