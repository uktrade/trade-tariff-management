Sequel.migration do
  up do
    add_column :footnote_association_measures_oplog, :added_by_id, Integer
    add_column :footnote_association_measures_oplog, :added_at, Time

    run %Q{
      CREATE OR REPLACE VIEW footnote_association_measures AS
       SELECT footnote_association_measures1.measure_sid,
          footnote_association_measures1.footnote_type_id,
          footnote_association_measures1.footnote_id,
          footnote_association_measures1."national",
          footnote_association_measures1.oid,
          footnote_association_measures1.operation,
          footnote_association_measures1.operation_date,
          footnote_association_measures1.added_at,
          footnote_association_measures1.added_by_id
         FROM footnote_association_measures_oplog footnote_association_measures1
        WHERE ((footnote_association_measures1.oid IN ( SELECT max(footnote_association_measures2.oid) AS max
                 FROM footnote_association_measures_oplog footnote_association_measures2
                WHERE ((footnote_association_measures1.measure_sid = footnote_association_measures2.measure_sid) AND ((footnote_association_measures1.footnote_id)::text = (footnote_association_measures2.footnote_id)::text) AND ((footnote_association_measures1.footnote_type_id)::text = (footnote_association_measures2.footnote_type_id)::text)))) AND ((footnote_association_measures1.operation)::text <> 'D'::text));
    }
  end

  down do
    run %Q{
      CREATE OR REPLACE VIEW footnote_association_measures AS
       SELECT footnote_association_measures1.measure_sid,
          footnote_association_measures1.footnote_type_id,
          footnote_association_measures1.footnote_id,
          footnote_association_measures1."national",
          footnote_association_measures1.oid,
          footnote_association_measures1.operation,
          footnote_association_measures1.operation_date
         FROM footnote_association_measures_oplog footnote_association_measures1
        WHERE ((footnote_association_measures1.oid IN ( SELECT max(footnote_association_measures2.oid) AS max
                 FROM footnote_association_measures_oplog footnote_association_measures2
                WHERE ((footnote_association_measures1.measure_sid = footnote_association_measures2.measure_sid) AND ((footnote_association_measures1.footnote_id)::text = (footnote_association_measures2.footnote_id)::text) AND ((footnote_association_measures1.footnote_type_id)::text = (footnote_association_measures2.footnote_type_id)::text)))) AND ((footnote_association_measures1.operation)::text <> 'D'::text));
    }
  end
end
