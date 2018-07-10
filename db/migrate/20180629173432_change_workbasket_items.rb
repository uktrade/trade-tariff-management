Sequel.migration do
  change do
    alter_table :workbasket_items do
      rename_column :data, :original_data
      add_column :new_data, :jsonb, default: '{}'
    end
  end
end
