Sequel.migration do
  change do
    alter_table :edit_geographical_areas_workbasket_settings do
      add_column :original_geographical_area_sid, String
      add_column :original_geographical_area_id, String
    end
  end
end
