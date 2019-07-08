Sequel.migration do
  change do
    create_table :edit_nomenclature_workbasket_settings do
      primary_key :id
      Integer :workbasket_id

      String :workbasket_name
      String :reason_for_changes
      Date   :validity_start_date
      String :description

      String :original_nomenclature

      Time :created_at
      Time :updated_at
    end
  end
end
