Sequel.migration do
  change do
    create_table :delete_quota_suspension_workbasket_settings do
      primary_key :id
      Integer :workbasket_id

      String :quota_suspension_period_sid

      Boolean :main_step_validation_passed, default: false

      Time :created_at
      Time :updated_at
    end
  end
end
