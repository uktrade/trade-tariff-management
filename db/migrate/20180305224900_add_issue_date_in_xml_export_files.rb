Sequel.migration do
  up do
    alter_table :xml_export_files do
      drop_column :issue_date
      add_column :issue_date, DateTime
    end
  end
end
