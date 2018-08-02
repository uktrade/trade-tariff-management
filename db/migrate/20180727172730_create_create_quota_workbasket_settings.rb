Sequel.migration do
  change do
    create_table :create_quota_workbasket_settings do
      primary_key :id
      Integer :workbasket_id
    end
  end
end
