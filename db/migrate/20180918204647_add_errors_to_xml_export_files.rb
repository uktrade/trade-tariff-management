Sequel.migration do
  change do
    alter_table :xml_export_files do
      add_column :errors, :jsonb, default: '{}'
    end
  end
end
