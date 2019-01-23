class ProrogationRegulationAction < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: %i[prorogation_regulation_id
                                 prorogation_regulation_role
                                 prorogated_regulation_id
                                 prorogated_regulation_role]
  plugin :conformance_validator

  set_primary_key %i[prorogation_regulation_id prorogation_regulation_role
                     prorogated_regulation_id prorogated_regulation_role]

  def record_code
    "295".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
