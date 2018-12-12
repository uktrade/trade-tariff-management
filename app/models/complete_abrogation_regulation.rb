class CompleteAbrogationRegulation < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::RegulationDocumentContext
  include ::RegulationAbrogationContext
  include ::WorkbasketHelpers::Association

  set_primary_key %i[complete_abrogation_regulation_id complete_abrogation_regulation_role]

  plugin :oplog, primary_key: %i[complete_abrogation_regulation_id complete_abrogation_regulation_role]
  plugin :conformance_validator

  def record_code
    "275".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
