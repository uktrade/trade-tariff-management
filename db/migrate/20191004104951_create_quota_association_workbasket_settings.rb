Sequel.migration do
  change do
    create_table :create_quota_association_workbasket_settings do
      primary_key :id

      Integer :workbasket_id

      String :parent_quota_order_id
      String :child_quota_order_id

      String :parent_quota_definition_period
      String :child_quota_definition_period
      String :relation_type
      String :coefficient

      Boolean :main_step_validation_passed, default: false

      Time :created_at
      Time :updated_at

    end
  end
end
