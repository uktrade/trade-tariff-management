Sequel.migration do
  change do
    create_table :db_rollbacks do
      primary_key :id
      String :state, size: 1
      DateTime :issue_date
      Date :clear_date
      Time :updated_at
      Time :created_at
    end
  end
end
