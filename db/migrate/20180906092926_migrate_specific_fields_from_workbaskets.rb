Sequel.migration do
  change do
    alter_table :workbaskets do
      drop_column :initial_items_populated
      drop_column :batches_loaded
      drop_column :search_code
      drop_column :all_batched_loaded
      drop_column :initial_search_results_code
    end

    alter_table :bulk_edit_of_measures_settings do
      add_column :search_code, String
      add_column :initial_search_results_code, String

      add_column :initial_items_populated, :boolean, default: false
      add_column :batches_loaded, :jsonb, default: '{}'
    end
  end
end

