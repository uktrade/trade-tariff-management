class CertificateTypeDescription < Sequel::Model
  plugin :oplog, primary_key: :certificate_type_code
  plugin :conformance_validator

  set_primary_key [:certificate_type_code]

  def record_code
    "110".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
