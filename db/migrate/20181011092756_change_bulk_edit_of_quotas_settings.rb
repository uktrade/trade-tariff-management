Sequel.migration do
  up do
    alter_table :bulk_edit_of_quotas_settings do
      drop_column :search_code
      drop_column :quota_sids_jsonb

      add_column :quota_sid, Integer
    end
  end

  down do
    alter_table :bulk_edit_of_quotas_settings do
      drop_column :quota_sid

      add_column :search_code, :text
      add_column :quota_sids_jsonb, :jsonb, default: '{}'
    end
  end
end
