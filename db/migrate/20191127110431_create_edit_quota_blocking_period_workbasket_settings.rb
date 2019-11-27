Sequel.migration do
  change do
    create_table :edit_quota_blocking_period_workbasket_settings do
      primary_key :id
      Integer :workbasket_id
      String :description
      Date :start_date
      Date :end_date
      String :quota_order_number_id
      String :quota_definition_sid
      String :quota_blocking_period_sid
      String :blocking_period_type
      Boolean :main_step_validation_passed, default: false
      Time :created_at
      Time :updated_at
    end
  end
end
