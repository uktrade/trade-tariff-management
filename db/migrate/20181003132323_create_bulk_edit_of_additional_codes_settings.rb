Sequel.migration do
  change do
    create_table :bulk_edit_of_additional_codes_settings do
      primary_key :id
      Integer :workbasket_id
      Jsonb :main_step_settings_jsonb, default: '{}'
      Boolean :main_step_validation_passed, default: false
      String :search_code
      String :initial_search_results_code
      Boolean :initial_items_populated, default: false
      Jsonb :batches_loaded, default: '{}'
      Jsonb :additional_code_sids_jsonb, default: '{}'
      Time :created_at
      Time :updated_at
    end
  end
end
