class CertificateDescriptionPeriod < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: [:certificate_description_period_sid]
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key [:certificate_description_period_sid]

  one_to_one :certificate_description, key: :certificate_description_period_sid,
                                       primary_key: :certificate_description_period_sid

  def record_code
    "205".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
