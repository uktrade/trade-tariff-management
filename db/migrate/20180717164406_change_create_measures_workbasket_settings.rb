Sequel.migration do
  change do
    alter_table :create_measures_workbasket_settings do
      rename_column :settings_jsonb, :main_step_settings_jsonb
      add_column :duties_conditions_footnotes_step_settings_jsonb, :jsonb, default: '{}'
    end
  end
end
