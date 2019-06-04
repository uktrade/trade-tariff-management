class GeographicalAreaMembership < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :time_machine
  plugin :oplog, primary_key: %i[geographical_area_sid
                                 geographical_area_group_sid
                                 validity_start_date]
  plugin :conformance_validator

  set_primary_key %i[geographical_area_sid geographical_area_group_sid
                     validity_start_date]

  one_to_one :geographical_area, key: :geographical_area_sid,
                                 primary_key: :geographical_area_sid

  def record_code
    "250".freeze
  end

  def subrecord_code
    "15".freeze
  end

  dataset_module do
    def started_memberships
      where{validity_start_date <= Date.today}
    end

    def not_end_dated
      where("validity_end_date > :date or validity_end_date is NULL", date: Date.today)
    end
  end
end
