class MeasureActionDescription < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :action_code
  plugin :conformance_validator

  set_primary_key [:action_code]

  def record_code
    "355".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
