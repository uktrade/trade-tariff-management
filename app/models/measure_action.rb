class MeasureAction < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :time_machine
  plugin :oplog, primary_key: :action_code
  plugin :conformance_validator

  set_primary_key [:action_code]

  many_to_one :measure_action_description, key: :action_code,
                                           primary_key: :action_code

  delegate :description, to: :measure_action_description

  def record_code
    "355".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      action_code: action_code,
      description: description
    }
  end
end
