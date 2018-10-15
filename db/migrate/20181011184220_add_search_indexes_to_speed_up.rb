Sequel.migration do
  change do
    add_index :geographical_areas_oplog, :geographical_area_sid
    add_index :geographical_areas_oplog, :geographical_area_id
    add_index :geographical_areas_oplog, :parent_geographical_area_group_sid
    add_index :geographical_areas_oplog, :geographical_code

    add_index :base_regulations_oplog, :base_regulation_id
    add_index :base_regulations_oplog, :base_regulation_role

    add_index :measure_excluded_geographical_areas_oplog, :measure_sid
    add_index :measure_excluded_geographical_areas_oplog, :excluded_geographical_area
    add_index :measure_excluded_geographical_areas_oplog, :geographical_area_sid

    add_index :measure_components_oplog, :measure_sid
    add_index :measure_components_oplog, :duty_expression_id

    add_index :duty_expressions_oplog, :duty_expression_id
    add_index :duty_expression_descriptions_oplog, :duty_expression_id

    add_index :footnote_association_measures_oplog, :measure_sid
    add_index :footnote_association_measures_oplog, :footnote_type_id
    add_index :footnote_association_measures_oplog, :footnote_id

    add_index :footnotes_oplog, :footnote_type_id
    add_index :footnotes_oplog, :footnote_id

    add_index :footnote_types_oplog, :footnote_type_id
    add_index :footnote_types_oplog, :application_code

    add_index :footnote_type_descriptions_oplog, :footnote_type_id

    add_index :measure_conditions_oplog, :measure_condition_sid
    add_index :measure_conditions_oplog, :condition_code

    add_index :measure_condition_code_descriptions_oplog, :condition_code
  end
end
