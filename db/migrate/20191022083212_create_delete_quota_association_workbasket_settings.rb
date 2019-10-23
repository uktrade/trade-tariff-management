Sequel.migration do
  change do
    create_table :delete_quota_association_workbasket_settings do
      primary_key :id

      Integer :workbasket_id

      String :main_quota_definition_sid
      String :sub_quota_definition_sid

      Boolean :main_step_validation_passed, default: false

      Time :created_at
      Time :updated_at
    end
  end
end
