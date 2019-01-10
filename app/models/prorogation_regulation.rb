class ProrogationRegulation < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::RegulationDocumentContext
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: %i[prorogation_regulation_id
                                 prorogation_regulation_role]
  plugin :conformance_validator

  set_primary_key %i[prorogation_regulation_id prorogation_regulation_role]

  def record_code
    "295".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
