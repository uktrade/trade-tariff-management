Sequel.migration do
  change do
    add_column :xml_export_files, :meta_data, :text
  end
end
