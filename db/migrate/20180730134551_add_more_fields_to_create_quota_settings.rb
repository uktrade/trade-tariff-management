Sequel.migration do
  change do
    alter_table :create_quota_workbasket_settings do
      add_column :main_step_settings_jsonb, :jsonb, default: '{}'
      add_column :configure_quota_step_settings_jsonb, :jsonb, default: '{}'
      add_column :conditions_footnotes_step_settings_jsonb, :jsonb, default: '{}'
    end
  end
end
