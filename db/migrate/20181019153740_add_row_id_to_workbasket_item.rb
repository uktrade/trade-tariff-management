Sequel.migration do
  change do
    alter_table :workbasket_items do
      add_column :row_id, String
    end
  end
end
