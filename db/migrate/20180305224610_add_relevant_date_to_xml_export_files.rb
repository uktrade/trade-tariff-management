Sequel.migration do
  change do
    alter_table :xml_export_files do
      add_column :relevant_date, Date
    end
  end
end
