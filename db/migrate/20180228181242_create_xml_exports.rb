Sequel.migration do
  change do
    create_table :xml_export_files do
      primary_key :id
      String :filename, size: 30
      String :state, size: 1
      Date :issue_date
      Time :updated_at
      Time :created_at
    end
  end
end
