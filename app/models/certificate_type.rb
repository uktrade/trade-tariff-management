class CertificateType < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :certificate_type_code
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key [:certificate_type_code]

  many_to_one :certificate_type_description, key: :certificate_type_code,
                                             primary_key: :certificate_type_code,
                                             eager_loader_key: :certificate_type_code

  one_to_many :certificates, key: :certificate_type_code,
                             primary_key: :certificate_type_code

  delegate :description, to: :certificate_type_description

  def record_code
    "110".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
