class MeasurementUnitQualifier < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :time_machine
  plugin :oplog, primary_key: :measurement_unit_qualifier_code
  plugin :conformance_validator

  set_primary_key [:measurement_unit_qualifier_code]

  one_to_one :measurement_unit_qualifier_description, key: :measurement_unit_qualifier_code,
                                                      primary_key: :measurement_unit_qualifier_code

  delegate :formatted_measurement_unit_qualifier, :description, to: :measurement_unit_qualifier_description, allow_nil: true

  def record_code
    "215".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      measurement_unit_qualifier_code: measurement_unit_qualifier_code,
      description: description
    }
  end
end
