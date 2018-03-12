class DutyExpression < Sequel::Model

  include ::XmlGeneration::BaseHelper

  MEURSING_DUTY_EXPRESSION_IDS = %w[12 14 21 25 27 29]

  plugin :time_machine
  plugin :oplog, primary_key: :duty_expression_id
  plugin :conformance_validator

  set_primary_key [:duty_expression_id]

  one_to_one :duty_expression_description

  delegate :abbreviation, :description, to: :duty_expression_description

  def record_code
    "230".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
