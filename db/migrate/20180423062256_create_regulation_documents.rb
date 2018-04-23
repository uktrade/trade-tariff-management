Sequel.migration do
  change do
    create_table :regulation_documents do
      primary_key :id
      String :regulation_id
      String :regulation_role
      String :regulation_id_key
      String :regulation_role_key
      Text :pdf_data
    end
  end
end
