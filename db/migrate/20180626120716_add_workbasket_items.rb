Sequel.migration do
  change do
    create_table :workbasket_items do
      primary_key :id
      Integer :workbasket_id
      Integer :record_id
      String :record_type
      String :status

      Time :updated_at
      Time :created_at
    end
  end
end
