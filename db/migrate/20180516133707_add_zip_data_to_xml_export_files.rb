Sequel.migration do
  change do
    add_column :xml_export_files, :zip_data, :text
  end
end
