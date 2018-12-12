class MeursingTablePlan < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :meursing_table_plan_id
  plugin :conformance_validator

  set_primary_key [:meursing_table_plan_id]

  def record_code
    "320".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
