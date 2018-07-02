Sequel.migration do
  change do
    alter_table :workbaskets do
      add_column :all_batched_loaded, :boolean, default: false
    end
  end
end
