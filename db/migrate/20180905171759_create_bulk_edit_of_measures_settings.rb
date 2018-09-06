Sequel.migration do
  change do
    create_table :bulk_edit_of_measures_settings do
      primary_key :id
      Integer :workbasket_id
      Jsonb :main_step_settings_jsonb, default: '{}'
      Boolean :main_step_validation_passed, default: false
      Time :created_at
      Time :updated_at
    end
  end
end
