Sequel.migration do
  up do
    alter_table :xml_export_files do
      drop_column :date_filters
      add_column  :workbasket_selected, Integer
    end
  end

  down do
    alter_table :xml_export_files do
      add_column  :date_filters, String
      drop_column :workbasket_selected
    end
  end
end
