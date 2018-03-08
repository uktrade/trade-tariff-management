Sequel.migration do
  up do
    alter_table :xml_export_files do
      drop_column :filename
    end
  end

  down do
    alter_table :xml_export_files do
      add_column :filename, String
    end
  end
end
