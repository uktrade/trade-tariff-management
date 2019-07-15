Sequel.migration do
  up do
    add_column :goods_nomenclature_description_periods_oplog, :added_by_id, Integer
    add_column :goods_nomenclature_description_periods_oplog, :added_at, Time
    add_column :goods_nomenclature_description_periods_oplog, :national, :boolean
    add_column :goods_nomenclature_descriptions_oplog, :added_by_id, Integer
    add_column :goods_nomenclature_descriptions_oplog, :added_at, Time
    add_column :goods_nomenclature_descriptions_oplog, :national, :boolean

    run %Q{

CREATE OR REPLACE VIEW public.goods_nomenclature_description_periods AS
 SELECT goods_nomenclature_description_periods1.goods_nomenclature_description_period_sid,
    goods_nomenclature_description_periods1.goods_nomenclature_sid,
    goods_nomenclature_description_periods1.validity_start_date,
    goods_nomenclature_description_periods1.goods_nomenclature_item_id,
    goods_nomenclature_description_periods1.productline_suffix,
    goods_nomenclature_description_periods1.validity_end_date,
    goods_nomenclature_description_periods1.oid,
    goods_nomenclature_description_periods1.operation,
    goods_nomenclature_description_periods1.operation_date,
    goods_nomenclature_description_periods1.status,
    goods_nomenclature_description_periods1.workbasket_id,
    goods_nomenclature_description_periods1.workbasket_sequence_number,
    goods_nomenclature_description_periods1.added_by_id,
    goods_nomenclature_description_periods1.added_at,
    goods_nomenclature_description_periods1.national
   FROM public.goods_nomenclature_description_periods_oplog goods_nomenclature_description_periods1
  WHERE ((goods_nomenclature_description_periods1.oid IN ( SELECT max(goods_nomenclature_description_periods2.oid) AS max
           FROM public.goods_nomenclature_description_periods_oplog goods_nomenclature_description_periods2
          WHERE (goods_nomenclature_description_periods1.goods_nomenclature_description_period_sid = goods_nomenclature_description_periods2.goods_nomenclature_description_period_sid))) AND ((goods_nomenclature_description_periods1.operation)::text <> 'D'::text));

CREATE OR REPLACE VIEW public.goods_nomenclature_descriptions AS
 SELECT goods_nomenclature_descriptions1.goods_nomenclature_description_period_sid,
    goods_nomenclature_descriptions1.language_id,
    goods_nomenclature_descriptions1.goods_nomenclature_sid,
    goods_nomenclature_descriptions1.goods_nomenclature_item_id,
    goods_nomenclature_descriptions1.productline_suffix,
    goods_nomenclature_descriptions1.description,
    goods_nomenclature_descriptions1.oid,
    goods_nomenclature_descriptions1.operation,
    goods_nomenclature_descriptions1.operation_date,
    goods_nomenclature_descriptions1.status,
    goods_nomenclature_descriptions1.workbasket_id,
    goods_nomenclature_descriptions1.workbasket_sequence_number,
    goods_nomenclature_descriptions1.added_by_id,
    goods_nomenclature_descriptions1.added_at,
    goods_nomenclature_descriptions1.national
   FROM public.goods_nomenclature_descriptions_oplog goods_nomenclature_descriptions1
  WHERE ((goods_nomenclature_descriptions1.oid IN ( SELECT max(goods_nomenclature_descriptions2.oid) AS max
           FROM public.goods_nomenclature_descriptions_oplog goods_nomenclature_descriptions2
          WHERE ((goods_nomenclature_descriptions1.goods_nomenclature_sid = goods_nomenclature_descriptions2.goods_nomenclature_sid) AND (goods_nomenclature_descriptions1.goods_nomenclature_description_period_sid = goods_nomenclature_descriptions2.goods_nomenclature_description_period_sid)))) AND ((goods_nomenclature_descriptions1.operation)::text <> 'D'::text));
    }


  end

  down do

    run %Q{

DROP VIEW public.goods_nomenclature_description_periods;

CREATE OR REPLACE VIEW public.goods_nomenclature_description_periods AS
 SELECT goods_nomenclature_description_periods1.goods_nomenclature_description_period_sid,
    goods_nomenclature_description_periods1.goods_nomenclature_sid,
    goods_nomenclature_description_periods1.validity_start_date,
    goods_nomenclature_description_periods1.goods_nomenclature_item_id,
    goods_nomenclature_description_periods1.productline_suffix,
    goods_nomenclature_description_periods1.validity_end_date,
    goods_nomenclature_description_periods1.oid,
    goods_nomenclature_description_periods1.operation,
    goods_nomenclature_description_periods1.operation_date,
    goods_nomenclature_description_periods1.status,
    goods_nomenclature_description_periods1.workbasket_id,
    goods_nomenclature_description_periods1.workbasket_sequence_number
   FROM public.goods_nomenclature_description_periods_oplog goods_nomenclature_description_periods1
  WHERE ((goods_nomenclature_description_periods1.oid IN ( SELECT max(goods_nomenclature_description_periods2.oid) AS max
           FROM public.goods_nomenclature_description_periods_oplog goods_nomenclature_description_periods2
          WHERE (goods_nomenclature_description_periods1.goods_nomenclature_description_period_sid = goods_nomenclature_description_periods2.goods_nomenclature_description_period_sid))) AND ((goods_nomenclature_description_periods1.operation)::text <> 'D'::text));

DROP VIEW public.goods_nomenclature_descriptions;

CREATE VIEW public.goods_nomenclature_descriptions AS
 SELECT goods_nomenclature_descriptions1.goods_nomenclature_description_period_sid,
    goods_nomenclature_descriptions1.language_id,
    goods_nomenclature_descriptions1.goods_nomenclature_sid,
    goods_nomenclature_descriptions1.goods_nomenclature_item_id,
    goods_nomenclature_descriptions1.productline_suffix,
    goods_nomenclature_descriptions1.description,
    goods_nomenclature_descriptions1.oid,
    goods_nomenclature_descriptions1.operation,
    goods_nomenclature_descriptions1.operation_date,
    goods_nomenclature_descriptions1.status,
    goods_nomenclature_descriptions1.workbasket_id,
    goods_nomenclature_descriptions1.workbasket_sequence_number

   FROM public.goods_nomenclature_descriptions_oplog goods_nomenclature_descriptions1
  WHERE ((goods_nomenclature_descriptions1.oid IN ( SELECT max(goods_nomenclature_descriptions2.oid) AS max
           FROM public.goods_nomenclature_descriptions_oplog goods_nomenclature_descriptions2
          WHERE ((goods_nomenclature_descriptions1.goods_nomenclature_sid = goods_nomenclature_descriptions2.goods_nomenclature_sid) AND (goods_nomenclature_descriptions1.goods_nomenclature_description_period_sid = goods_nomenclature_descriptions2.goods_nomenclature_description_period_sid)))) AND ((goods_nomenclature_descriptions1.operation)::text <> 'D'::text));

    }

    drop_column :goods_nomenclature_descriptions_oplog, :added_by_id
    drop_column :goods_nomenclature_descriptions_oplog, :added_at
    drop_column :goods_nomenclature_descriptions_oplog, :national
    drop_column :goods_nomenclature_description_periods_oplog, :added_by_id
    drop_column :goods_nomenclature_description_periods_oplog, :added_at
    drop_column :goods_nomenclature_description_periods_oplog, :national

  end
end
