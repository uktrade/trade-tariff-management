Sequel.migration do
  change do
    alter_table :measure_components_oplog do
      add_column :original_duty_expression_id, String
    end

    alter_table :measure_condition_components_oplog do
      add_column :original_duty_expression_id, String
    end

    alter_table :measure_conditions_oplog do
      add_column :original_measure_condition_code, String
    end

    [
      :measure_components,
      :measure_condition_components,
      :measure_conditions
    ].map do |view_name|
      run "DROP VIEW public.#{view_name};"
    end

    run %Q{
      CREATE VIEW public.measure_components AS
       SELECT measure_components1.measure_sid,
          measure_components1.duty_expression_id,
          measure_components1.duty_amount,
          measure_components1.monetary_unit_code,
          measure_components1.measurement_unit_code,
          measure_components1.measurement_unit_qualifier_code,
          measure_components1.oid,
          measure_components1.operation,
          measure_components1.operation_date,
          measure_components1.added_by_id,
          measure_components1.added_at,
          measure_components1."national",
          measure_components1.status,
          measure_components1.workbasket_id,
          measure_components1.workbasket_sequence_number,
          measure_components1.original_duty_expression_id
         FROM public.measure_components_oplog measure_components1
        WHERE ((measure_components1.oid IN ( SELECT max(measure_components2.oid) AS max
                 FROM public.measure_components_oplog measure_components2
                WHERE ((measure_components1.measure_sid = measure_components2.measure_sid) AND ((measure_components1.duty_expression_id)::text = (measure_components2.duty_expression_id)::text)))) AND ((measure_components1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE VIEW public.measure_condition_components AS
       SELECT measure_condition_components1.measure_condition_sid,
          measure_condition_components1.duty_expression_id,
          measure_condition_components1.duty_amount,
          measure_condition_components1.monetary_unit_code,
          measure_condition_components1.measurement_unit_code,
          measure_condition_components1.measurement_unit_qualifier_code,
          measure_condition_components1.oid,
          measure_condition_components1.operation,
          measure_condition_components1.operation_date,
          measure_condition_components1.added_by_id,
          measure_condition_components1.added_at,
          measure_condition_components1."national",
          measure_condition_components1.status,
          measure_condition_components1.workbasket_id,
          measure_condition_components1.workbasket_sequence_number,
          measure_condition_components1.original_duty_expression_id
         FROM public.measure_condition_components_oplog measure_condition_components1
        WHERE ((measure_condition_components1.oid IN ( SELECT max(measure_condition_components2.oid) AS max
                 FROM public.measure_condition_components_oplog measure_condition_components2
                WHERE ((measure_condition_components1.measure_condition_sid = measure_condition_components2.measure_condition_sid) AND ((measure_condition_components1.duty_expression_id)::text = (measure_condition_components2.duty_expression_id)::text)))) AND ((measure_condition_components1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE VIEW public.measure_conditions AS
       SELECT measure_conditions1.measure_condition_sid,
          measure_conditions1.measure_sid,
          measure_conditions1.condition_code,
          measure_conditions1.component_sequence_number,
          measure_conditions1.condition_duty_amount,
          measure_conditions1.condition_monetary_unit_code,
          measure_conditions1.condition_measurement_unit_code,
          measure_conditions1.condition_measurement_unit_qualifier_code,
          measure_conditions1.action_code,
          measure_conditions1.certificate_type_code,
          measure_conditions1.certificate_code,
          measure_conditions1.oid,
          measure_conditions1.operation,
          measure_conditions1.operation_date,
          measure_conditions1.added_by_id,
          measure_conditions1.added_at,
          measure_conditions1."national",
          measure_conditions1.status,
          measure_conditions1.workbasket_id,
          measure_conditions1.workbasket_sequence_number,
          measure_conditions1.original_measure_condition_code
         FROM public.measure_conditions_oplog measure_conditions1
        WHERE ((measure_conditions1.oid IN ( SELECT max(measure_conditions2.oid) AS max
                 FROM public.measure_conditions_oplog measure_conditions2
                WHERE (measure_conditions1.measure_condition_sid = measure_conditions2.measure_condition_sid))) AND ((measure_conditions1.operation)::text <> 'D'::text));
    }
  end
end
