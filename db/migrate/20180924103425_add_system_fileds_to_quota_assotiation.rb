Sequel.migration do
  up do
    add_column :quota_associations_oplog, :added_by_id, Integer
    add_column :quota_associations_oplog, :added_at, Time
    add_column :quota_associations_oplog, :national, :boolean

    run %Q{
      CREATE OR REPLACE VIEW public.quota_associations AS
       SELECT quota_associations1.main_quota_definition_sid,
          quota_associations1.sub_quota_definition_sid,
          quota_associations1.relation_type,
          quota_associations1.coefficient,
          quota_associations1.oid,
          quota_associations1.operation,
          quota_associations1.operation_date,
          quota_associations1.status,
          quota_associations1.workbasket_id,
          quota_associations1.workbasket_sequence_number,
          quota_associations1.added_by_id,
          quota_associations1.added_at,
          quota_associations1.national
         FROM public.quota_associations_oplog quota_associations1
        WHERE ((quota_associations1.oid IN ( SELECT max(quota_associations2.oid) AS max
                 FROM public.quota_associations_oplog quota_associations2
                WHERE ((quota_associations1.main_quota_definition_sid = quota_associations2.main_quota_definition_sid) AND (quota_associations1.sub_quota_definition_sid = quota_associations2.sub_quota_definition_sid)))) AND ((quota_associations1.operation)::text <> 'D'::text));
    }

  end

  down do
    run %Q{
      CREATE VIEW public.quota_associations AS
       SELECT quota_associations1.main_quota_definition_sid,
          quota_associations1.sub_quota_definition_sid,
          quota_associations1.relation_type,
          quota_associations1.coefficient,
          quota_associations1.oid,
          quota_associations1.operation,
          quota_associations1.operation_date,
          quota_associations1.status,
          quota_associations1.workbasket_id,
          quota_associations1.workbasket_sequence_number
         FROM public.quota_associations_oplog quota_associations1
        WHERE ((quota_associations1.oid IN ( SELECT max(quota_associations2.oid) AS max
                 FROM public.quota_associations_oplog quota_associations2
                WHERE ((quota_associations1.main_quota_definition_sid = quota_associations2.main_quota_definition_sid) AND (quota_associations1.sub_quota_definition_sid = quota_associations2.sub_quota_definition_sid)))) AND ((quota_associations1.operation)::text <> 'D'::text));
    }

  end
end
