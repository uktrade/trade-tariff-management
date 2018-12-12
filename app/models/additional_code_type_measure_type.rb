class AdditionalCodeTypeMeasureType < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: %i[measure_type_id additional_code_type_id]
  plugin :conformance_validator

  set_primary_key %i[measure_type_id additional_code_type_id]

  many_to_one :measure_type
  many_to_one :additional_code_type

  def record_code
    "240".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
