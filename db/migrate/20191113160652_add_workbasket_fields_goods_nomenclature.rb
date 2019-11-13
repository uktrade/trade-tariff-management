Sequel.migration do

  up do
    add_column :goods_nomenclatures_oplog, :added_by_id, Integer
    add_column :goods_nomenclatures_oplog, :added_at, Time
    add_column :goods_nomenclatures_oplog, :national, :boolean
    add_column :goods_nomenclature_indents_oplog, :added_by_id, Integer
    add_column :goods_nomenclature_indents_oplog, :added_at, Time
    add_column :goods_nomenclature_indents_oplog, :national, :boolean
    add_column :goods_nomenclature_origins_oplog, :added_by_id, Integer
    add_column :goods_nomenclature_origins_oplog, :added_at, Time
    add_column :goods_nomenclature_origins_oplog, :national, :boolean

    run %Q{

CREATE OR REPLACE VIEW public.goods_nomenclatures AS
 SELECT goods_nomenclatures1.goods_nomenclature_sid,
    goods_nomenclatures1.goods_nomenclature_item_id,
    goods_nomenclatures1.producline_suffix,
    goods_nomenclatures1.validity_start_date,
    goods_nomenclatures1.validity_end_date,
    goods_nomenclatures1.statistical_indicator,
    goods_nomenclatures1.oid,
    goods_nomenclatures1.operation,
    goods_nomenclatures1.operation_date,
    goods_nomenclatures1.status,
    goods_nomenclatures1.workbasket_id,
    goods_nomenclatures1.workbasket_sequence_number,
    goods_nomenclatures1.added_by_id,
    goods_nomenclatures1.added_at,
    goods_nomenclatures1.national
   FROM public.goods_nomenclatures_oplog goods_nomenclatures1
  WHERE ((goods_nomenclatures1.oid IN ( SELECT max(goods_nomenclatures2.oid) AS max
           FROM public.goods_nomenclatures_oplog goods_nomenclatures2
          WHERE (goods_nomenclatures1.goods_nomenclature_sid = goods_nomenclatures2.goods_nomenclature_sid))) AND ((goods_nomenclatures1.operation)::text <> 'D'::text));


CREATE OR REPLACE VIEW public.goods_nomenclature_indents AS
 SELECT goods_nomenclature_indents1.goods_nomenclature_indent_sid,
    goods_nomenclature_indents1.goods_nomenclature_sid,
    goods_nomenclature_indents1.validity_start_date,
    goods_nomenclature_indents1.number_indents,
    goods_nomenclature_indents1.goods_nomenclature_item_id,
    goods_nomenclature_indents1.productline_suffix,
    goods_nomenclature_indents1.validity_end_date,
    goods_nomenclature_indents1.oid,
    goods_nomenclature_indents1.operation,
    goods_nomenclature_indents1.operation_date,
    goods_nomenclature_indents1.status,
    goods_nomenclature_indents1.workbasket_id,
    goods_nomenclature_indents1.workbasket_sequence_number,
    goods_nomenclature_indents1.added_by_id,
    goods_nomenclature_indents1.added_at,
    goods_nomenclature_indents1.national
   FROM public.goods_nomenclature_indents_oplog goods_nomenclature_indents1
  WHERE ((goods_nomenclature_indents1.oid IN ( SELECT max(goods_nomenclature_indents2.oid) AS max
           FROM public.goods_nomenclature_indents_oplog goods_nomenclature_indents2
          WHERE (goods_nomenclature_indents1.goods_nomenclature_indent_sid = goods_nomenclature_indents2.goods_nomenclature_indent_sid))) AND ((goods_nomenclature_indents1.operation)::text <> 'D'::text));

CREATE OR REPLACE VIEW public.goods_nomenclature_origins AS
 SELECT goods_nomenclature_origins1.goods_nomenclature_sid,
    goods_nomenclature_origins1.derived_goods_nomenclature_item_id,
    goods_nomenclature_origins1.derived_productline_suffix,
    goods_nomenclature_origins1.goods_nomenclature_item_id,
    goods_nomenclature_origins1.productline_suffix,
    goods_nomenclature_origins1.oid,
    goods_nomenclature_origins1.operation,
    goods_nomenclature_origins1.operation_date,
    goods_nomenclature_origins1.status,
    goods_nomenclature_origins1.workbasket_id,
    goods_nomenclature_origins1.workbasket_sequence_number,
    goods_nomenclature_origins1.added_by_id,
    goods_nomenclature_origins1.added_at,
    goods_nomenclature_origins1.national
   FROM public.goods_nomenclature_origins_oplog goods_nomenclature_origins1
  WHERE ((goods_nomenclature_origins1.oid IN ( SELECT max(goods_nomenclature_origins2.oid) AS max
           FROM public.goods_nomenclature_origins_oplog goods_nomenclature_origins2
          WHERE ((goods_nomenclature_origins1.goods_nomenclature_sid = goods_nomenclature_origins2.goods_nomenclature_sid) AND ((goods_nomenclature_origins1.derived_goods_nomenclature_item_id)::text = (goods_nomenclature_origins2.derived_goods_nomenclature_item_id)::text) AND ((goods_nomenclature_origins1.derived_productline_suffix)::text = (goods_nomenclature_origins2.derived_productline_suffix)::text) AND ((goods_nomenclature_origins1.goods_nomenclature_item_id)::text = (goods_nomenclature_origins2.goods_nomenclature_item_id)::text) AND ((goods_nomenclature_origins1.productline_suffix)::text = (goods_nomenclature_origins2.productline_suffix)::text)))) AND ((goods_nomenclature_origins1.operation)::text <> 'D'::text));

    }
  end

  down do
    run %Q{

DROP VIEW public.goods_nomenclatures;

CREATE VIEW public.goods_nomenclatures AS
 SELECT goods_nomenclatures1.goods_nomenclature_sid,
    goods_nomenclatures1.goods_nomenclature_item_id,
    goods_nomenclatures1.producline_suffix,
    goods_nomenclatures1.validity_start_date,
    goods_nomenclatures1.validity_end_date,
    goods_nomenclatures1.statistical_indicator,
    goods_nomenclatures1.oid,
    goods_nomenclatures1.operation,
    goods_nomenclatures1.operation_date,
    goods_nomenclatures1.status,
    goods_nomenclatures1.workbasket_id,
    goods_nomenclatures1.workbasket_sequence_number
   FROM public.goods_nomenclatures_oplog goods_nomenclatures1
  WHERE ((goods_nomenclatures1.oid IN ( SELECT max(goods_nomenclatures2.oid) AS max
           FROM public.goods_nomenclatures_oplog goods_nomenclatures2
          WHERE (goods_nomenclatures1.goods_nomenclature_sid = goods_nomenclatures2.goods_nomenclature_sid))) AND ((goods_nomenclatures1.operation)::text <> 'D'::text));

DROP VIEW public.goods_nomenclature_indents;

CREATE VIEW public.goods_nomenclature_indents AS
 SELECT goods_nomenclature_indents1.goods_nomenclature_indent_sid,
    goods_nomenclature_indents1.goods_nomenclature_sid,
    goods_nomenclature_indents1.validity_start_date,
    goods_nomenclature_indents1.number_indents,
    goods_nomenclature_indents1.goods_nomenclature_item_id,
    goods_nomenclature_indents1.productline_suffix,
    goods_nomenclature_indents1.validity_end_date,
    goods_nomenclature_indents1.oid,
    goods_nomenclature_indents1.operation,
    goods_nomenclature_indents1.operation_date,
    goods_nomenclature_indents1.status,
    goods_nomenclature_indents1.workbasket_id,
    goods_nomenclature_indents1.workbasket_sequence_number
   FROM public.goods_nomenclature_indents_oplog goods_nomenclature_indents1
  WHERE ((goods_nomenclature_indents1.oid IN ( SELECT max(goods_nomenclature_indents2.oid) AS max
           FROM public.goods_nomenclature_indents_oplog goods_nomenclature_indents2
          WHERE (goods_nomenclature_indents1.goods_nomenclature_indent_sid = goods_nomenclature_indents2.goods_nomenclature_indent_sid))) AND ((goods_nomenclature_indents1.operation)::text <> 'D'::text));


DROP VIEW public.goods_nomenclature_origins;

CREATE VIEW public.goods_nomenclature_origins AS
 SELECT goods_nomenclature_origins1.goods_nomenclature_sid,
    goods_nomenclature_origins1.derived_goods_nomenclature_item_id,
    goods_nomenclature_origins1.derived_productline_suffix,
    goods_nomenclature_origins1.goods_nomenclature_item_id,
    goods_nomenclature_origins1.productline_suffix,
    goods_nomenclature_origins1.oid,
    goods_nomenclature_origins1.operation,
    goods_nomenclature_origins1.operation_date,
    goods_nomenclature_origins1.status,
    goods_nomenclature_origins1.workbasket_id,
    goods_nomenclature_origins1.workbasket_sequence_number
   FROM public.goods_nomenclature_origins_oplog goods_nomenclature_origins1
  WHERE ((goods_nomenclature_origins1.oid IN ( SELECT max(goods_nomenclature_origins2.oid) AS max
           FROM public.goods_nomenclature_origins_oplog goods_nomenclature_origins2
          WHERE ((goods_nomenclature_origins1.goods_nomenclature_sid = goods_nomenclature_origins2.goods_nomenclature_sid) AND ((goods_nomenclature_origins1.derived_goods_nomenclature_item_id)::text = (goods_nomenclature_origins2.derived_goods_nomenclature_item_id)::text) AND ((goods_nomenclature_origins1.derived_productline_suffix)::text = (goods_nomenclature_origins2.derived_productline_suffix)::text) AND ((goods_nomenclature_origins1.goods_nomenclature_item_id)::text = (goods_nomenclature_origins2.goods_nomenclature_item_id)::text) AND ((goods_nomenclature_origins1.productline_suffix)::text = (goods_nomenclature_origins2.productline_suffix)::text)))) AND ((goods_nomenclature_origins1.operation)::text <> 'D'::text));

    }

    drop_column :goods_nomenclatures_oplog, :added_by_id
    drop_column :goods_nomenclatures_oplog, :added_at
    drop_column :goods_nomenclatures_oplog, :national
    drop_column :goods_nomenclature_indents_oplog, :added_by_id
    drop_column :goods_nomenclature_indents_oplog, :added_at
    drop_column :goods_nomenclature_indents_oplog, :national
    drop_column :goods_nomenclature_origins_oplog, :added_by_id
    drop_column :goods_nomenclature_origins_oplog, :added_at
    drop_column :goods_nomenclature_origins_oplog, :national
  end
end
