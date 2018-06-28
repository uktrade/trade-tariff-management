Sequel.migration do
  change do
    alter_table :workbaskets do
      add_column :initial_items_populated, :boolean, default: false
    end
  end
end
