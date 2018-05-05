Sequel.migration do
  up do
    add_column :footnotes_oplog, :added_by_id, Integer
    add_column :footnotes_oplog, :added_at, Time

    run %Q{
      CREATE OR REPLACE VIEW footnotes AS
       SELECT footnotes1.footnote_id,
          footnotes1.footnote_type_id,
          footnotes1.validity_start_date,
          footnotes1.validity_end_date,
          footnotes1."national",
          footnotes1.oid,
          footnotes1.operation,
          footnotes1.operation_date,
          footnotes1.added_by_id,
          footnotes1.added_at
         FROM footnotes_oplog footnotes1
        WHERE ((footnotes1.oid IN ( SELECT max(footnotes2.oid) AS max
                 FROM footnotes_oplog footnotes2
                WHERE (((footnotes1.footnote_type_id)::text = (footnotes2.footnote_type_id)::text) AND ((footnotes1.footnote_id)::text = (footnotes2.footnote_id)::text)))) AND ((footnotes1.operation)::text <> 'D'::text));
    }
  end

  down do
    run %Q{
      CREATE OR REPLACE VIEW footnotes AS
       SELECT footnotes1.footnote_id,
          footnotes1.footnote_type_id,
          footnotes1.validity_start_date,
          footnotes1.validity_end_date,
          footnotes1."national",
          footnotes1.oid,
          footnotes1.operation,
          footnotes1.operation_date
         FROM footnotes_oplog footnotes1
        WHERE ((footnotes1.oid IN ( SELECT max(footnotes2.oid) AS max
                 FROM footnotes_oplog footnotes2
                WHERE (((footnotes1.footnote_type_id)::text = (footnotes2.footnote_type_id)::text) AND ((footnotes1.footnote_id)::text = (footnotes2.footnote_id)::text)))) AND ((footnotes1.operation)::text <> 'D'::text));
    }
  end
end
