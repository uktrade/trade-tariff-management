Sequel.migration do
  change do
    alter_table :workbaskets do
      add_column :search_code, String
    end
  end
end
