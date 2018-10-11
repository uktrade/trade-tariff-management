Sequel.migration do
  up do
    alter_table :bulk_edit_of_quotas_settings do
      drop_column :search_code
      drop_column :initial_items_populated
      drop_column :batches_loaded
      drop_column :quota_sids_jsonb

      add_column :measures_search_code, String
      add_column :measures_initial_items_populated, :boolean, default: false
      add_column :measures_batches_loaded, :jsonb, default: '{}'
      add_column :quota_sid, Integer
    end
  end

  down do
    alter_table :bulk_edit_of_quotas_settings do
      drop_column :measures_search_code
      drop_column :measures_initial_items_populated
      drop_column :measures_batches_loaded
      drop_column :quota_sid

      add_column :search_code, :text
      add_column :initial_items_populated, :boolean, default: false
      add_column :batches_loaded, :jsonb, default: '{}'
      add_column :quota_sids_jsonb, :jsonb, default: '{}'
    end
  end
end
