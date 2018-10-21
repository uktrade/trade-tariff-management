Sequel.migration do
  up do
    add_column :footnote_association_goods_nomenclatures_oplog, :added_by_id, Integer
    add_column :footnote_association_goods_nomenclatures_oplog, :added_at, Time

    run %Q{
      CREATE OR REPLACE VIEW public.footnote_association_goods_nomenclatures AS
       SELECT footnote_association_goods_nomenclatures1.goods_nomenclature_sid,
          footnote_association_goods_nomenclatures1.footnote_type,
          footnote_association_goods_nomenclatures1.footnote_id,
          footnote_association_goods_nomenclatures1.validity_start_date,
          footnote_association_goods_nomenclatures1.validity_end_date,
          footnote_association_goods_nomenclatures1.goods_nomenclature_item_id,
          footnote_association_goods_nomenclatures1.productline_suffix,
          footnote_association_goods_nomenclatures1."national",
          footnote_association_goods_nomenclatures1.oid,
          footnote_association_goods_nomenclatures1.operation,
          footnote_association_goods_nomenclatures1.operation_date,
          footnote_association_goods_nomenclatures1.status,
          footnote_association_goods_nomenclatures1.workbasket_id,
          footnote_association_goods_nomenclatures1.workbasket_sequence_number,
          footnote_association_goods_nomenclatures1.added_by_id,
          footnote_association_goods_nomenclatures1.added_at
         FROM public.footnote_association_goods_nomenclatures_oplog footnote_association_goods_nomenclatures1
        WHERE ((footnote_association_goods_nomenclatures1.oid IN ( SELECT max(footnote_association_goods_nomenclatures2.oid) AS max
                 FROM public.footnote_association_goods_nomenclatures_oplog footnote_association_goods_nomenclatures2
                WHERE (((footnote_association_goods_nomenclatures1.footnote_id)::text = (footnote_association_goods_nomenclatures2.footnote_id)::text) AND ((footnote_association_goods_nomenclatures1.footnote_type)::text = (footnote_association_goods_nomenclatures2.footnote_type)::text) AND (footnote_association_goods_nomenclatures1.goods_nomenclature_sid = footnote_association_goods_nomenclatures2.goods_nomenclature_sid)))) AND ((footnote_association_goods_nomenclatures1.operation)::text <> 'D'::text));
    }
  end
end
