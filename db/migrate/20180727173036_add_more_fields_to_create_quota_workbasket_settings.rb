Sequel.migration do
  change do
    alter_table :create_quota_workbasket_settings do
      add_column :settings_jsonb, :jsonb, default: '{}'
      add_column :measure_sids_jsonb, :jsonb, default: '{}'
      add_column :quota_period_sids_jsonb, :jsonb, default: '{}'

      add_column :main_step_validation_passed, :boolean, default: false
      add_column :configure_quota_step_validation_passed, :boolean, default: false
      add_column :conditions_footnotes_step_validation_passed, :boolean, default: false

      add_column :created_at, :time
      add_column :updated_at, :time
    end
  end
end
