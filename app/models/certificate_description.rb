class CertificateDescription < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: [:certificate_description_period_sid]
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key [:certificate_description_period_sid]

  one_to_one :certificate_description_period, key: :certificate_description_period_sid,
                                              primary_key: :certificate_description_period_sid

  def to_s
    description
  end

  def record_code
    "205".freeze
  end

  def subrecord_code
    "10".freeze
  end
end
