Sequel.migration do
  change do
    alter_table :workbaskets do
      add_column :initial_search_results_code, String
    end
  end
end
