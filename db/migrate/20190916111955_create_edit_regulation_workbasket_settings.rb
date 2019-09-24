Sequel.migration do
  change do
    create_table :edit_regulation_workbasket_settings do
      primary_key :id

      Integer :workbasket_id

      String :reason_for_changes

      String :original_base_regulation_id
      String :original_base_regulation_role

      String :base_regulation_id
      String :legal_id
      String :description
      String :reference_url
      Date   :validity_start_date
      Date   :validity_end_date
      String :regulation_group_id

      Boolean :main_step_validation_passed, default: false

      Time :created_at
      Time :updated_at
    end
  end
end
