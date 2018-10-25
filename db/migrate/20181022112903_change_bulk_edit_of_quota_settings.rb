Sequel.migration do
  up do
    alter_table :bulk_edit_of_quotas_settings do
      drop_column :quota_main_step_settings_jsonb

      add_column :configure_step_settings_jsonb, :jsonb, default: '{}'

      add_column :configure_quota_step_validation_passed, :boolean, default: false
      add_column :conditions_footnotes_step_validation_passed, :boolean, default: false

      add_column :measure_sids_jsonb, :jsonb, default: '{}'
      add_column :quota_period_sids_jsonb, :jsonb, default: '{}'
      add_column :parent_quota_period_sids_jsonb, :jsonb, default: '{}'
    end
  end

  down do
    alter_table :bulk_edit_of_quotas_settings do
      add_column :quota_main_step_settings_jsonb, :jsonb, default: '{}'

      drop_column :configure_step_settings_jsonb

      drop_column :configure_quota_step_validation_passed
      drop_column :conditions_footnotes_step_validation_passed

      drop_column :measure_sids_jsonb
      drop_column :quota_period_sids_jsonb
      drop_column :parent_quota_period_sids_jsonb
    end
  end
end
