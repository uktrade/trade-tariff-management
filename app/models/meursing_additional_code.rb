class MeursingAdditionalCode < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: :meursing_additional_code_sid
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key  [:meursing_additional_code_sid]

  def code
    "7#{additional_code}"
  end

  def record_code
    "340".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
