Sequel.migration do
  change do
    alter_table :xml_export_files do
      add_column :validation_errors, :jsonb, default: '{}'
    end
  end
end
