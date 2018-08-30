Sequel.migration do
  change do
    create_table :create_regulation_workbasket_settings do
      primary_key :id
      Integer :workbasket_id
      Jsonb :main_step_settings_jsonb, default: '{}'
      Time :created_at
      Time :updated_at
    end
  end
end
