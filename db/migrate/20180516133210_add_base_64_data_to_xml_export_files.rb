Sequel.migration do
  change do
    add_column :xml_export_files, :base_64_data, :text
  end
end
