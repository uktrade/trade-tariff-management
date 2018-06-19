Sequel.migration do
  change do
    create_table :workbaskets do
      primary_key :id
      String :title
      String :type
      String :status
      Integer :user_id

      Integer :last_update_by_id
      Time :last_status_change_at

      Time :updated_at
      Time :created_at
    end
  end
end
