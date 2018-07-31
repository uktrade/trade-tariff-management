Sequel.migration do
  change do
    run "DROP VIEW public.measure_excluded_geographical_areas;"

    alter_table :measure_excluded_geographical_areas_oplog do
      add_column :status, String
      add_column :workbasket_id, Integer
      add_column :workbasket_sequence_number, Integer
    end

    run %Q{
      CREATE VIEW public.measure_excluded_geographical_areas AS
       SELECT measure_excluded_geographical_areas1.measure_sid,
          measure_excluded_geographical_areas1.excluded_geographical_area,
          measure_excluded_geographical_areas1.geographical_area_sid,
          measure_excluded_geographical_areas1.oid,
          measure_excluded_geographical_areas1.operation,
          measure_excluded_geographical_areas1.operation_date,
          measure_excluded_geographical_areas1.added_by_id,
          measure_excluded_geographical_areas1.added_at,
          measure_excluded_geographical_areas1."national",
          measure_excluded_geographical_areas1.status,
          measure_excluded_geographical_areas1.workbasket_id,
          measure_excluded_geographical_areas1.workbasket_sequence_number
         FROM public.measure_excluded_geographical_areas_oplog measure_excluded_geographical_areas1
        WHERE ((measure_excluded_geographical_areas1.oid IN ( SELECT max(measure_excluded_geographical_areas2.oid) AS max
                 FROM public.measure_excluded_geographical_areas_oplog measure_excluded_geographical_areas2
                WHERE ((measure_excluded_geographical_areas1.measure_sid = measure_excluded_geographical_areas2.measure_sid) AND (measure_excluded_geographical_areas1.geographical_area_sid = measure_excluded_geographical_areas2.geographical_area_sid)))) AND ((measure_excluded_geographical_areas1.operation)::text <> 'D'::text));
    }
  end
end
