Sequel.migration do
  change do
    alter_table :edit_nomenclature_workbasket_settings do
      add_column :main_step_validation_passed, :boolean, default: false
    end
  end
end
