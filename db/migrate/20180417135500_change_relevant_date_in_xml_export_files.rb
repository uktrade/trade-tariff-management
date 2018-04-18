Sequel.migration do
  up do
    alter_table :xml_export_files do
      drop_column :relevant_date
      add_column :date_filters, :text
    end
  end
end
