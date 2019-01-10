class MeasureTypeDescription < Sequel::Model
  include ::XmlGeneration::BaseHelper

  set_primary_key [:measure_type_id]
  plugin :oplog, primary_key: :measure_type_id
  plugin :conformance_validator

  one_to_one :measure_type, key: :measure_type_id,
                            foreign_key: :measure_type_id

  def to_s
    description
  end

  def record_code
    "235".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
