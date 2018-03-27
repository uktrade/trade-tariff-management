class MonetaryUnit < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :monetary_unit_code
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key [:monetary_unit_code]

  one_to_one :monetary_unit_description, key: :monetary_unit_code,
                                         primary_key: :monetary_unit_code

  delegate :description, :abbreviation, to: :monetary_unit_description

  def to_s
    monetary_unit_code
  end

  def record_code
    "225".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
