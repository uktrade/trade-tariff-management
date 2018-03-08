Sequel.migration do
  change do
    add_column :xml_export_files, :xml_data, :text
  end
end
