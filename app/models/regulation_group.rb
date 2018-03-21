class RegulationGroup < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :regulation_group_id
  plugin :conformance_validator

  set_primary_key [:regulation_group_id]

  one_to_many :base_regulations

  def record_code
    "150".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
