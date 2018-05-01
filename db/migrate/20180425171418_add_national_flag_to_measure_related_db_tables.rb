Sequel.migration do
  up do
    %w(
      quota_order_numbers_oplog
      quota_order_number_origins_oplog
      quota_order_number_origin_exclusions_oplog
      quota_definitions_oplog
      measure_excluded_geographical_areas_oplog
      measure_components_oplog
      measure_conditions_oplog
      measure_condition_components_oplog
    ).map do |table_name|
      add_column table_name, :added_by_id, Integer
      add_column table_name, :added_at, Time
      add_column table_name, :national, :boolean
    end

    run %Q{
      CREATE OR REPLACE VIEW quota_order_numbers AS
       SELECT quota_order_numbers1.quota_order_number_sid,
          quota_order_numbers1.quota_order_number_id,
          quota_order_numbers1.validity_start_date,
          quota_order_numbers1.validity_end_date,
          quota_order_numbers1.oid,
          quota_order_numbers1.operation,
          quota_order_numbers1.operation_date,
          quota_order_numbers1.added_by_id,
          quota_order_numbers1.added_at,
          quota_order_numbers1.national
         FROM quota_order_numbers_oplog quota_order_numbers1
        WHERE ((quota_order_numbers1.oid IN ( SELECT max(quota_order_numbers2.oid) AS max
                 FROM quota_order_numbers_oplog quota_order_numbers2
                WHERE (quota_order_numbers1.quota_order_number_sid = quota_order_numbers2.quota_order_number_sid))) AND ((quota_order_numbers1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW quota_order_number_origins AS
       SELECT quota_order_number_origins1.quota_order_number_origin_sid,
          quota_order_number_origins1.quota_order_number_sid,
          quota_order_number_origins1.geographical_area_id,
          quota_order_number_origins1.validity_start_date,
          quota_order_number_origins1.validity_end_date,
          quota_order_number_origins1.geographical_area_sid,
          quota_order_number_origins1.oid,
          quota_order_number_origins1.operation,
          quota_order_number_origins1.operation_date,
          quota_order_number_origins1.added_by_id,
          quota_order_number_origins1.added_at,
          quota_order_number_origins1.national
         FROM quota_order_number_origins_oplog quota_order_number_origins1
        WHERE ((quota_order_number_origins1.oid IN ( SELECT max(quota_order_number_origins2.oid) AS max
                 FROM quota_order_number_origins_oplog quota_order_number_origins2
                WHERE (quota_order_number_origins1.quota_order_number_origin_sid = quota_order_number_origins2.quota_order_number_origin_sid))) AND ((quota_order_number_origins1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW quota_order_number_origin_exclusions AS
       SELECT quota_order_number_origin_exclusions1.quota_order_number_origin_sid,
          quota_order_number_origin_exclusions1.excluded_geographical_area_sid,
          quota_order_number_origin_exclusions1.oid,
          quota_order_number_origin_exclusions1.operation,
          quota_order_number_origin_exclusions1.operation_date,
          quota_order_number_origin_exclusions1.added_by_id,
          quota_order_number_origin_exclusions1.added_at,
          quota_order_number_origin_exclusions1.national
         FROM quota_order_number_origin_exclusions_oplog quota_order_number_origin_exclusions1
        WHERE ((quota_order_number_origin_exclusions1.oid IN ( SELECT max(quota_order_number_origin_exclusions2.oid) AS max
                 FROM quota_order_number_origin_exclusions_oplog quota_order_number_origin_exclusions2
                WHERE ((quota_order_number_origin_exclusions1.quota_order_number_origin_sid = quota_order_number_origin_exclusions2.quota_order_number_origin_sid) AND (quota_order_number_origin_exclusions1.excluded_geographical_area_sid = quota_order_number_origin_exclusions2.excluded_geographical_area_sid)))) AND ((quota_order_number_origin_exclusions1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW quota_definitions AS
       SELECT quota_definitions1.quota_definition_sid,
          quota_definitions1.quota_order_number_id,
          quota_definitions1.validity_start_date,
          quota_definitions1.validity_end_date,
          quota_definitions1.quota_order_number_sid,
          quota_definitions1.volume,
          quota_definitions1.initial_volume,
          quota_definitions1.measurement_unit_code,
          quota_definitions1.maximum_precision,
          quota_definitions1.critical_state,
          quota_definitions1.critical_threshold,
          quota_definitions1.monetary_unit_code,
          quota_definitions1.measurement_unit_qualifier_code,
          quota_definitions1.description,
          quota_definitions1.oid,
          quota_definitions1.operation,
          quota_definitions1.operation_date,
          quota_definitions1.added_by_id,
          quota_definitions1.added_at,
          quota_definitions1.national
         FROM quota_definitions_oplog quota_definitions1
        WHERE ((quota_definitions1.oid IN ( SELECT max(quota_definitions2.oid) AS max
                 FROM quota_definitions_oplog quota_definitions2
                WHERE (quota_definitions1.quota_definition_sid = quota_definitions2.quota_definition_sid))) AND ((quota_definitions1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW measure_excluded_geographical_areas AS
       SELECT measure_excluded_geographical_areas1.measure_sid,
          measure_excluded_geographical_areas1.excluded_geographical_area,
          measure_excluded_geographical_areas1.geographical_area_sid,
          measure_excluded_geographical_areas1.oid,
          measure_excluded_geographical_areas1.operation,
          measure_excluded_geographical_areas1.operation_date,
          measure_excluded_geographical_areas1.added_by_id,
          measure_excluded_geographical_areas1.added_at,
          measure_excluded_geographical_areas1.national
         FROM measure_excluded_geographical_areas_oplog measure_excluded_geographical_areas1
        WHERE ((measure_excluded_geographical_areas1.oid IN ( SELECT max(measure_excluded_geographical_areas2.oid) AS max
                 FROM measure_excluded_geographical_areas_oplog measure_excluded_geographical_areas2
                WHERE ((measure_excluded_geographical_areas1.measure_sid = measure_excluded_geographical_areas2.measure_sid) AND (measure_excluded_geographical_areas1.geographical_area_sid = measure_excluded_geographical_areas2.geographical_area_sid)))) AND ((measure_excluded_geographical_areas1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW measure_components AS
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
          measure_components1.national
         FROM measure_components_oplog measure_components1
        WHERE ((measure_components1.oid IN ( SELECT max(measure_components2.oid) AS max
                 FROM measure_components_oplog measure_components2
                WHERE ((measure_components1.measure_sid = measure_components2.measure_sid) AND ((measure_components1.duty_expression_id)::text = (measure_components2.duty_expression_id)::text)))) AND ((measure_components1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW measure_conditions AS
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
          measure_conditions1.national
         FROM measure_conditions_oplog measure_conditions1
        WHERE ((measure_conditions1.oid IN ( SELECT max(measure_conditions2.oid) AS max
                 FROM measure_conditions_oplog measure_conditions2
                WHERE (measure_conditions1.measure_condition_sid = measure_conditions2.measure_condition_sid))) AND ((measure_conditions1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW measure_condition_components AS
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
          measure_condition_components1.national
         FROM measure_condition_components_oplog measure_condition_components1
        WHERE ((measure_condition_components1.oid IN ( SELECT max(measure_condition_components2.oid) AS max
                 FROM measure_condition_components_oplog measure_condition_components2
                WHERE ((measure_condition_components1.measure_condition_sid = measure_condition_components2.measure_condition_sid) AND ((measure_condition_components1.duty_expression_id)::text = (measure_condition_components2.duty_expression_id)::text)))) AND ((measure_condition_components1.operation)::text <> 'D'::text));
    }
  end

  down do
    run %Q{
      CREATE OR REPLACE VIEW quota_order_numbers AS
       SELECT quota_order_numbers1.quota_order_number_sid,
          quota_order_numbers1.quota_order_number_id,
          quota_order_numbers1.validity_start_date,
          quota_order_numbers1.validity_end_date,
          quota_order_numbers1.oid,
          quota_order_numbers1.operation,
          quota_order_numbers1.operation_date
         FROM quota_order_numbers_oplog quota_order_numbers1
        WHERE ((quota_order_numbers1.oid IN ( SELECT max(quota_order_numbers2.oid) AS max
                 FROM quota_order_numbers_oplog quota_order_numbers2
                WHERE (quota_order_numbers1.quota_order_number_sid = quota_order_numbers2.quota_order_number_sid))) AND ((quota_order_numbers1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW quota_order_number_origins AS
       SELECT quota_order_number_origins1.quota_order_number_origin_sid,
          quota_order_number_origins1.quota_order_number_sid,
          quota_order_number_origins1.geographical_area_id,
          quota_order_number_origins1.validity_start_date,
          quota_order_number_origins1.validity_end_date,
          quota_order_number_origins1.geographical_area_sid,
          quota_order_number_origins1.oid,
          quota_order_number_origins1.operation,
          quota_order_number_origins1.operation_date
         FROM quota_order_number_origins_oplog quota_order_number_origins1
        WHERE ((quota_order_number_origins1.oid IN ( SELECT max(quota_order_number_origins2.oid) AS max
                 FROM quota_order_number_origins_oplog quota_order_number_origins2
                WHERE (quota_order_number_origins1.quota_order_number_origin_sid = quota_order_number_origins2.quota_order_number_origin_sid))) AND ((quota_order_number_origins1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW quota_order_number_origin_exclusions AS
       SELECT quota_order_number_origin_exclusions1.quota_order_number_origin_sid,
          quota_order_number_origin_exclusions1.excluded_geographical_area_sid,
          quota_order_number_origin_exclusions1.oid,
          quota_order_number_origin_exclusions1.operation,
          quota_order_number_origin_exclusions1.operation_date
         FROM quota_order_number_origin_exclusions_oplog quota_order_number_origin_exclusions1
        WHERE ((quota_order_number_origin_exclusions1.oid IN ( SELECT max(quota_order_number_origin_exclusions2.oid) AS max
                 FROM quota_order_number_origin_exclusions_oplog quota_order_number_origin_exclusions2
                WHERE ((quota_order_number_origin_exclusions1.quota_order_number_origin_sid = quota_order_number_origin_exclusions2.quota_order_number_origin_sid) AND (quota_order_number_origin_exclusions1.excluded_geographical_area_sid = quota_order_number_origin_exclusions2.excluded_geographical_area_sid)))) AND ((quota_order_number_origin_exclusions1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW quota_definitions AS
       SELECT quota_definitions1.quota_definition_sid,
          quota_definitions1.quota_order_number_id,
          quota_definitions1.validity_start_date,
          quota_definitions1.validity_end_date,
          quota_definitions1.quota_order_number_sid,
          quota_definitions1.volume,
          quota_definitions1.initial_volume,
          quota_definitions1.measurement_unit_code,
          quota_definitions1.maximum_precision,
          quota_definitions1.critical_state,
          quota_definitions1.critical_threshold,
          quota_definitions1.monetary_unit_code,
          quota_definitions1.measurement_unit_qualifier_code,
          quota_definitions1.description,
          quota_definitions1.oid,
          quota_definitions1.operation,
          quota_definitions1.operation_date
         FROM quota_definitions_oplog quota_definitions1
        WHERE ((quota_definitions1.oid IN ( SELECT max(quota_definitions2.oid) AS max
                 FROM quota_definitions_oplog quota_definitions2
                WHERE (quota_definitions1.quota_definition_sid = quota_definitions2.quota_definition_sid))) AND ((quota_definitions1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW measure_excluded_geographical_areas AS
       SELECT measure_excluded_geographical_areas1.measure_sid,
          measure_excluded_geographical_areas1.excluded_geographical_area,
          measure_excluded_geographical_areas1.geographical_area_sid,
          measure_excluded_geographical_areas1.oid,
          measure_excluded_geographical_areas1.operation,
          measure_excluded_geographical_areas1.operation_date
         FROM measure_excluded_geographical_areas_oplog measure_excluded_geographical_areas1
        WHERE ((measure_excluded_geographical_areas1.oid IN ( SELECT max(measure_excluded_geographical_areas2.oid) AS max
                 FROM measure_excluded_geographical_areas_oplog measure_excluded_geographical_areas2
                WHERE ((measure_excluded_geographical_areas1.measure_sid = measure_excluded_geographical_areas2.measure_sid) AND (measure_excluded_geographical_areas1.geographical_area_sid = measure_excluded_geographical_areas2.geographical_area_sid)))) AND ((measure_excluded_geographical_areas1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW measure_components AS
       SELECT measure_components1.measure_sid,
          measure_components1.duty_expression_id,
          measure_components1.duty_amount,
          measure_components1.monetary_unit_code,
          measure_components1.measurement_unit_code,
          measure_components1.measurement_unit_qualifier_code,
          measure_components1.oid,
          measure_components1.operation,
          measure_components1.operation_date
         FROM measure_components_oplog measure_components1
        WHERE ((measure_components1.oid IN ( SELECT max(measure_components2.oid) AS max
                 FROM measure_components_oplog measure_components2
                WHERE ((measure_components1.measure_sid = measure_components2.measure_sid) AND ((measure_components1.duty_expression_id)::text = (measure_components2.duty_expression_id)::text)))) AND ((measure_components1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW measure_conditions AS
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
          measure_conditions1.operation_date
         FROM measure_conditions_oplog measure_conditions1
        WHERE ((measure_conditions1.oid IN ( SELECT max(measure_conditions2.oid) AS max
                 FROM measure_conditions_oplog measure_conditions2
                WHERE (measure_conditions1.measure_condition_sid = measure_conditions2.measure_condition_sid))) AND ((measure_conditions1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW measure_condition_components AS
       SELECT measure_condition_components1.measure_condition_sid,
          measure_condition_components1.duty_expression_id,
          measure_condition_components1.duty_amount,
          measure_condition_components1.monetary_unit_code,
          measure_condition_components1.measurement_unit_code,
          measure_condition_components1.measurement_unit_qualifier_code,
          measure_condition_components1.oid,
          measure_condition_components1.operation,
          measure_condition_components1.operation_date
         FROM measure_condition_components_oplog measure_condition_components1
        WHERE ((measure_condition_components1.oid IN ( SELECT max(measure_condition_components2.oid) AS max
                 FROM measure_condition_components_oplog measure_condition_components2
                WHERE ((measure_condition_components1.measure_condition_sid = measure_condition_components2.measure_condition_sid) AND ((measure_condition_components1.duty_expression_id)::text = (measure_condition_components2.duty_expression_id)::text)))) AND ((measure_condition_components1.operation)::text <> 'D'::text));
    }
  end
end
