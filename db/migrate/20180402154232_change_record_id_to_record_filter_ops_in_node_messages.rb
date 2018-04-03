Sequel.migration do
  up do
    alter_table :node_messages do
      drop_column :record_id
      add_column :record_filter_ops, :text
    end
  end
end
