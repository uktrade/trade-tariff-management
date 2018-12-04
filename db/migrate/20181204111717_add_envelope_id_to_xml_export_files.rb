Sequel.migration do
  change do
    alter_table :xml_export_files do
      add_column :envelope_id, Integer
      add_index :envelope_id, unique: true
    end
  end
end
