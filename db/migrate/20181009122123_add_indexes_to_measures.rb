Sequel.migration do
  change do
    add_index :measure_conditions_oplog, :measure_sid
    add_index :quota_order_numbers_oplog, :quota_order_number_id
    add_index :quota_order_number_origins_oplog, :quota_order_number_sid
    add_index :quota_order_number_origin_exclusions_oplog, :quota_order_number_origin_sid
    add_index :quota_definitions_oplog, :quota_order_number_id
    add_index :measures_oplog, :measure_type_id
  end
end
