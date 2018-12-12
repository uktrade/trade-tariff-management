class MeursingHeadingText < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: %i[meursing_table_plan_id
                                 meursing_heading_number
                                 row_column_code]
  plugin :conformance_validator

  set_primary_key %i[meursing_table_plan_id meursing_heading_number row_column_code]

  def record_code
    "325".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
