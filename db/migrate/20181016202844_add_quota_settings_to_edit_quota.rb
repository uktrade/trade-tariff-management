Sequel.migration do
  change do
    alter_table :bulk_edit_of_quotas_settings do
      add_column :quota_settings_jsonb, :jsonb, default: '{}'
    end
  end
end
