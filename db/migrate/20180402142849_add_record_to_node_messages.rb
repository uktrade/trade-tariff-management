Sequel.migration do
  change do
    alter_table :node_messages do
      add_column :record_id, String
      add_column :record_type, String
    end
  end
end
