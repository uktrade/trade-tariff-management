class FootnoteAssociationMeursingHeading < Sequel::Model
  plugin :oplog, primary_key: [:measure_sid,
                               :footnote_id,
                               :meursing_table_plan_id]
  plugin :conformance_validator

  set_primary_key [:footnote_id, :meursing_table_plan_id]

  def record_code
    "325".freeze
  end

  def subrecord_code
    "10".freeze
  end
end
