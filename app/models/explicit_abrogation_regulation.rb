class ExplicitAbrogationRegulation < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::RegulationDocumentContext
  include ::RegulationAbrogationContext
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: %i[oid explicit_abrogation_regulation_id explicit_abrogation_regulation_role]
  plugin :conformance_validator

  set_primary_key %i[explicit_abrogation_regulation_id explicit_abrogation_regulation_role]

  def record_code
    "280".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
