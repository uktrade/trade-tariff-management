class PublicationSigle < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: [:oid, :code, :code_type_id]
  plugin :conformance_validator

  set_primary_key [:code, :code_type_id]

  def record_code
    "170".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
