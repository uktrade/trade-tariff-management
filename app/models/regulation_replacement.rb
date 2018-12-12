class RegulationReplacement < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: %i[replacing_regulation_id
                                 replacing_regulation_role
                                 replaced_regulation_id
                                 replaced_regulation_role]
  plugin :conformance_validator

  set_primary_key %i[replacing_regulation_id replacing_regulation_role
                     replaced_regulation_id replaced_regulation_role]

  def record_code
    "305".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
