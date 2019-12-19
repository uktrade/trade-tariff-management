Sequel.migration do
  change do
    create_table :edit_nomenclature_dates_workbasket_settings do
      primary_key :id
      Integer :workbasket_id

      String :workbasket_name
      String :reason_for_changes
      String :original_nomenclature
      Date   :validity_start_date
      Date   :validity_end_date

      Boolean :main_step_validation_passed, default: false

      Time :created_at
      Time :updated_at
    end
  end
end
