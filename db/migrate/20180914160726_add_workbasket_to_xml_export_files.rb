Sequel.migration do
  change do
    alter_table :xml_export_files do
      add_column :workbasket, :boolean, default: true
    end
  end
end
