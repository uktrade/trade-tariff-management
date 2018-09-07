Sequel.migration do
  change do
    alter_table :bulk_edit_of_measures_settings do
      add_column :measure_sids_jsonb, :jsonb, default: '{}'
    end
  end
end
