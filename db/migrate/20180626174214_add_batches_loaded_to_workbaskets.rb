Sequel.migration do
  change do
    alter_table :workbaskets do
      add_column :batches_loaded, :jsonb, default: '{}'
    end
  end
end
