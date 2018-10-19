Sequel.migration do
  up do
    alter_table :bulk_edit_of_quotas_settings do
      drop_column :quota_settings_jsonb
      drop_column :quota_sid

      add_column :initial_quota_sid, Integer
      add_column :quota_main_step_settings_jsonb, :jsonb, default: '{}'
      add_column :configure_quota_step_settings_jsonb, :jsonb, default: '{}'
      add_column :conditions_footnotes_step_settings_jsonb, :jsonb, default: '{}'
    end

    alter_table :create_quota_workbasket_settings do
      add_column :initial_quota_sid, Integer
      add_column :initial_search_results_code, String
    end

  end

  down do
    alter_table :create_quota_workbasket_settings do
      drop_column :initial_quota_sid
      drop_column :initial_search_results_code
    end

    alter_table :bulk_edit_of_quotas_settings do
      drop_column :quota_main_step_settings_jsonb
      drop_column :configure_quota_step_settings_jsonb
      drop_column :conditions_footnotes_step_settings_jsonb
      drop_column :initial_quota_sid

      add_column :quota_settings_jsonb, :jsonb, default: '{}'
      add_column :quota_sid, Integer
    end
  end
end
