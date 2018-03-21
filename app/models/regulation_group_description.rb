class RegulationGroupDescription < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :regulation_group_id
  plugin :conformance_validator

  set_primary_key [:regulation_group_id]

  def record_code
    "150".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
