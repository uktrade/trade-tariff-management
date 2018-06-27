Sequel.migration do
  change do
    alter_table :workbasket_items do
      add_column :data, :jsonb, default: '{}'
    end
  end
end
