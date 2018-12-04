Sequel.migration do
  change do
    alter_table :xml_export_files do
      add_column :envelope_id, String
      add_index :envelope_id, unique: true
    end
  end
end
