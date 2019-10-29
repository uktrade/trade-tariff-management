Sequel.migration do
  change do
    create_table :create_nomenclature_workbasket_settings do
      primary_key :id

      Integer :workbasket_id

      String :workbasket_name
      String :reason_for_changes
      String :parent_nomenclature_sid
      Date   :validity_start_date

      String :goods_nomenclature_item_id
      String :description
      String :producline_suffix
      Integer :number_indents

      String :origin_nomenclature
      String :origin_producline_suffix

      Boolean :main_step_validation_passed, default: false

      Time :created_at
      Time :updated_at

    end
  end
end
