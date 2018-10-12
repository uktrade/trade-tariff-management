Sequel.migration do
  change do
    add_index :measures_oplog, :measure_sid
    add_index :measures_oplog, :validity_start_date
    add_index :measures_oplog, :validity_end_date
    add_index :measures_oplog, :operation_date
    add_index :measures_oplog, :workbasket_id
    add_index :measures_oplog, :status
    add_index :measures_oplog, :geographical_area_id
    add_index :measures_oplog, :goods_nomenclature_item_id
    add_index :measures_oplog, :measure_generating_regulation_role
    add_index :measures_oplog, :measure_generating_regulation_id
    add_index :measures_oplog, :justification_regulation_role
    add_index :measures_oplog, :justification_regulation_id
    add_index :measures_oplog, :geographical_area_sid
    add_index :measures_oplog, :goods_nomenclature_sid
    add_index :measures_oplog, :additional_code_type_id
    add_index :measures_oplog, :additional_code_id
    add_index :measures_oplog, :additional_code_sid
    add_index :measures_oplog, :reduction_indicator
    add_index :measures_oplog, :export_refund_nomenclature_sid
  end
end
