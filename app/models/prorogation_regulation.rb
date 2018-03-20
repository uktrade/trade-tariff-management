class ProrogationRegulation < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: [:prorogation_regulation_id,
                               :prorogation_regulation_role]
  plugin :conformance_validator

  set_primary_key [:prorogation_regulation_id, :prorogation_regulation_role]
end


