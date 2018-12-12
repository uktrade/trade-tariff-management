class GeographicalAreaDescriptionPeriod < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: %i[geographical_area_description_period_sid
                                 geographical_area_sid]
  plugin :conformance_validator
  plugin :time_machine

  set_primary_key %i[geographical_area_description_period_sid geographical_area_sid]

  one_to_one :geographical_area_description, key: :geographical_area_description_period_sid,
                                             primary_key: :geographical_area_description_period_sid

  def record_code
    "250".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
