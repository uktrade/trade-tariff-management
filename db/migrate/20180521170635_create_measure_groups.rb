Sequel.migration do
  change do
    create_table :measure_groups do
      primary_key :id
      String :name
      String :status
      Integer :added_by_id
      Integer :last_update_by_id
      Time :last_status_change_at
      Time :updated_at
      Time :created_at
    end
  end
end
