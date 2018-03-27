class MeasurementUnitQualifierDescription < Sequel::Model
  include Formatter
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :measurement_unit_qualifier_code
  plugin :conformance_validator

  set_primary_key [:measurement_unit_qualifier_code]

  format :formatted_measurement_unit_qualifier, with: DescriptionFormatter,
                                                using: :description

  def record_code
    "215".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
