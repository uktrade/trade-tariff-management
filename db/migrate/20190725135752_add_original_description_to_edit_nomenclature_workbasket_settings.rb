Sequel.migration do
  change do
    alter_table :edit_nomenclature_workbasket_settings do
      add_column :original_description, String
    end
  end
end
