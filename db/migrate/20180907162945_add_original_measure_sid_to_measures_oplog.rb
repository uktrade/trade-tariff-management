Sequel.migration do
  change do
    alter_table :measures_oplog do
      add_column :original_measure_sid, String
    end

    run "DROP VIEW public.measures;"

    run %Q{
      CREATE VIEW public.measures AS
       SELECT measures1.measure_sid,
          measures1.measure_type_id,
          measures1.geographical_area_id,
          measures1.goods_nomenclature_item_id,
          measures1.validity_start_date,
          measures1.validity_end_date,
          measures1.measure_generating_regulation_role,
          measures1.measure_generating_regulation_id,
          measures1.justification_regulation_role,
          measures1.justification_regulation_id,
          measures1.stopped_flag,
          measures1.geographical_area_sid,
          measures1.goods_nomenclature_sid,
          measures1.ordernumber,
          measures1.additional_code_type_id,
          measures1.additional_code_id,
          measures1.additional_code_sid,
          measures1.reduction_indicator,
          measures1.export_refund_nomenclature_sid,
          measures1."national",
          measures1.tariff_measure_number,
          measures1.invalidated_by,
          measures1.invalidated_at,
          measures1.oid,
          measures1.operation,
          measures1.operation_date,
          measures1.added_by_id,
          measures1.added_at,
          measures1.status,
          measures1.last_status_change_at,
          measures1.last_update_by_id,
          measures1.updated_at,
          measures1.workbasket_id,
          measures1.searchable_data,
          measures1.searchable_data_updated_at,
          measures1.workbasket_sequence_number,
          measures1.original_measure_sid
         FROM public.measures_oplog measures1
        WHERE ((measures1.oid IN ( SELECT max(measures2.oid) AS max
                 FROM public.measures_oplog measures2
                WHERE (measures1.measure_sid = measures2.measure_sid))) AND ((measures1.operation)::text <> 'D'::text));
    }
  end
end
