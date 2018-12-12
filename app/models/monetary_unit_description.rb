class MonetaryUnitDescription < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :monetary_unit_code
  plugin :conformance_validator

  set_primary_key [:monetary_unit_code]

  def abbreviation
    {
      "EUC" => "EUR (EUC)",
    }[monetary_unit_code]
  end

  def record_code
    "225".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
