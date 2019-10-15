Sequel.migration do
  change do
    create_table :create_quota_suspension_workbasket_settings do
      primary_key :id

      Integer :workbasket_id

      String :description
      Date :start_date
      Date :end_date
      String :quota_order_number_id

      Boolean :main_step_validation_passed, default: false

      Time :created_at
      Time :updated_at
    end
  end
end
