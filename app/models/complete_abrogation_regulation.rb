class CompleteAbrogationRegulation < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::RegulationDocumentContext
  include ::RegulationAbrogationContext

  set_primary_key [:complete_abrogation_regulation_id, :complete_abrogation_regulation_role]

  plugin :oplog, primary_key: [:complete_abrogation_regulation_id, :complete_abrogation_regulation_role]
  plugin :conformance_validator

  def record_code
    "275".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
