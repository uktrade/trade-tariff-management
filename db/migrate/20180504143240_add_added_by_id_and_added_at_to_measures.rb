Sequel.migration do
  up do
    add_column :measures_oplog, :added_by_id, Integer
    add_column :measures_oplog, :added_at, Time

    run %Q{
      CREATE OR REPLACE VIEW measures AS
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
          measures1.added_at
         FROM measures_oplog measures1
        WHERE ((measures1.oid IN ( SELECT max(measures2.oid) AS max
                 FROM measures_oplog measures2
                WHERE (measures1.measure_sid = measures2.measure_sid))) AND ((measures1.operation)::text <> 'D'::text));
    }
  end

  down do
    run %Q{
      CREATE OR REPLACE VIEW measures AS
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
          measures1.operation_date
         FROM measures_oplog measures1
        WHERE ((measures1.oid IN ( SELECT max(measures2.oid) AS max
                 FROM measures_oplog measures2
                WHERE (measures1.measure_sid = measures2.measure_sid))) AND ((measures1.operation)::text <> 'D'::text));
    }
  end
end
