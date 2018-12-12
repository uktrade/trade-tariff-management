class MeursingTableCellComponent < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: %i[meursing_table_plan_id
                                 heading_number
                                 row_column_code
                                 meursing_additional_code_sid]
  plugin :conformance_validator

  set_primary_key %i[meursing_table_plan_id heading_number
                     row_column_code meursing_additional_code_sid]

  def record_code
    "340".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
