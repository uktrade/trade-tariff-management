Sequel.migration do
  change do
    create_table :workbaskets_events do
      primary_key :id
      Integer :workbasket_id
      Integer :user_id
      String :title
      String :description, text: true

      Time :updated_at
      Time :created_at
    end
  end
end
