Sequel.migration do
  change do
    alter_table :workbasket_items do
      add_column :changed_values, :jsonb, default: '{}'
      add_column :validation_errors, :jsonb, default: '{}'
    end
  end
end
