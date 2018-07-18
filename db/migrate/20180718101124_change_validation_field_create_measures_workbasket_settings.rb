Sequel.migration do
  change do
    alter_table :create_measures_workbasket_settings do
      rename_column :duties_conditions_footnotes_validation_passed,
                    :duties_conditions_footnotes_step_validation_passed
    end
  end
end
