Sequel.migration do
  change do
    alter_table :quota_definitions_oplog do
      add_column :workbasket_type_of_quota, String
    end

    run "DROP VIEW public.quota_definitions;"

    run %Q{
      CREATE VIEW public.quota_definitions AS
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
          quota_definitions1."national",
          quota_definitions1.status,
          quota_definitions1.workbasket_id,
          quota_definitions1.workbasket_sequence_number,
          quota_definitions1.workbasket_type_of_quota
         FROM public.quota_definitions_oplog quota_definitions1
        WHERE ((quota_definitions1.oid IN ( SELECT max(quota_definitions2.oid) AS max
                 FROM public.quota_definitions_oplog quota_definitions2
                WHERE (quota_definitions1.quota_definition_sid = quota_definitions2.quota_definition_sid))) AND ((quota_definitions1.operation)::text <> 'D'::text));
    }
  end
end
