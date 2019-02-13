Sequel.migration do
  change do
    alter_table :xml_export_files do
      add_column :user_id, Integer
    end
  end
end
