Sequel.migration do
  change do
    alter_table :create_measures_workbasket_settings do
      add_column :main_step_validation_passed, :boolean, default: false
      add_column :duties_conditions_footnotes_validation_passed, :boolean, default: false
    end
  end
end
