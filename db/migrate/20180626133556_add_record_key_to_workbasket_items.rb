Sequel.migration do
  change do
    alter_table :workbasket_items do
      add_column :record_key, String
    end
  end
end
