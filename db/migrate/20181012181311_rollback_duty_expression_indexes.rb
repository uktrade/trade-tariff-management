Sequel.migration do
  up do
    drop_index :measure_components_oplog, :measure_sid
    drop_index :measure_components_oplog, :duty_expression_id
  end

  down do
    add_index :measure_components_oplog, :measure_sid
    add_index :measure_components_oplog, :duty_expression_id
  end
end
