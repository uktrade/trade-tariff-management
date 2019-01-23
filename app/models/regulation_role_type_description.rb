class RegulationRoleTypeDescription < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :regulation_role_type_id
  plugin :conformance_validator

  set_primary_key [:regulation_role_type_id]

  def record_code
    "160".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
