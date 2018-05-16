Sequel.migration do
  change do
    add_column :regulation_documents, :national, :boolean
  end
end
