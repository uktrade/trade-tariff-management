Sequel.migration do
  up do
    alter_table :xml_export_files do
      drop_column :zip_data
      drop_column :base_64_data
    end
  end

  down do
    alter_table :xml_export_files do
      add_column :zip_data, String
      add_column :base_64_data, String
    end
  end

end
