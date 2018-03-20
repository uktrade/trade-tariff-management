class ExplicitAbrogationRegulation < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: [:oid, :explicit_abrogation_regulation_id, :explicit_abrogation_regulation_role]
  plugin :conformance_validator

  set_primary_key [:explicit_abrogation_regulation_id, :explicit_abrogation_regulation_role]
end


