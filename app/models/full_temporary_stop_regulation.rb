class FullTemporaryStopRegulation < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::RegulationDocumentContext
  include ::WorkbasketHelpers::Association

  plugin :time_machine
  plugin :oplog, primary_key: [:full_temporary_stop_regulation_id,
                               :full_temporary_stop_regulation_role]
  plugin :conformance_validator

  set_primary_key [:full_temporary_stop_regulation_id, :full_temporary_stop_regulation_role]

  one_to_one :complete_abrogation_regulation, key: [:complete_abrogation_regulation_id,
                                                    :complete_abrogation_regulation_role]
  one_to_one :explicit_abrogation_regulation,
             key: [ :explicit_abrogation_regulation_id,
                    :explicit_abrogation_regulation_role ]

  def regulation_id
    full_temporary_stop_regulation_id
  end

  def effective_end_date
    effective_enddate.to_date if effective_enddate.present?
  end

  def effective_start_date
    validity_start_date.to_date
  end

  def record_code
    "300".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
