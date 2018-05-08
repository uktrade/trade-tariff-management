Sequel.migration do
  up do
    %w(
      footnote_descriptions_oplog
      footnote_description_periods_oplog
    ).map do |table_name|
      add_column table_name, :added_by_id, Integer
      add_column table_name, :added_at, Time
    end

    run %Q{
      CREATE OR REPLACE VIEW footnote_descriptions AS
       SELECT footnote_descriptions1.footnote_description_period_sid,
          footnote_descriptions1.footnote_type_id,
          footnote_descriptions1.footnote_id,
          footnote_descriptions1.language_id,
          footnote_descriptions1.description,
          footnote_descriptions1."national",
          footnote_descriptions1.oid,
          footnote_descriptions1.operation,
          footnote_descriptions1.operation_date,
          footnote_descriptions1.added_at,
          footnote_descriptions1.added_by_id
         FROM footnote_descriptions_oplog footnote_descriptions1
        WHERE ((footnote_descriptions1.oid IN ( SELECT max(footnote_descriptions2.oid) AS max
                 FROM footnote_descriptions_oplog footnote_descriptions2
                WHERE ((footnote_descriptions1.footnote_description_period_sid = footnote_descriptions2.footnote_description_period_sid) AND ((footnote_descriptions1.footnote_id)::text = (footnote_descriptions2.footnote_id)::text) AND ((footnote_descriptions1.footnote_type_id)::text = (footnote_descriptions2.footnote_type_id)::text)))) AND ((footnote_descriptions1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW footnote_description_periods AS
       SELECT footnote_description_periods1.footnote_description_period_sid,
          footnote_description_periods1.footnote_type_id,
          footnote_description_periods1.footnote_id,
          footnote_description_periods1.validity_start_date,
          footnote_description_periods1.validity_end_date,
          footnote_description_periods1."national",
          footnote_description_periods1.oid,
          footnote_description_periods1.operation,
          footnote_description_periods1.operation_date,
          footnote_description_periods1.added_at,
          footnote_description_periods1.added_by_id
         FROM footnote_description_periods_oplog footnote_description_periods1
        WHERE ((footnote_description_periods1.oid IN ( SELECT max(footnote_description_periods2.oid) AS max
                 FROM footnote_description_periods_oplog footnote_description_periods2
                WHERE (((footnote_description_periods1.footnote_id)::text = (footnote_description_periods2.footnote_id)::text) AND ((footnote_description_periods1.footnote_type_id)::text = (footnote_description_periods2.footnote_type_id)::text) AND (footnote_description_periods1.footnote_description_period_sid = footnote_description_periods2.footnote_description_period_sid)))) AND ((footnote_description_periods1.operation)::text <> 'D'::text));
    }
  end

  down do
    run %Q{
      CREATE OR REPLACE VIEW footnote_descriptions AS
       SELECT footnote_descriptions1.footnote_description_period_sid,
          footnote_descriptions1.footnote_type_id,
          footnote_descriptions1.footnote_id,
          footnote_descriptions1.language_id,
          footnote_descriptions1.description,
          footnote_descriptions1."national",
          footnote_descriptions1.oid,
          footnote_descriptions1.operation,
          footnote_descriptions1.operation_date
         FROM footnote_descriptions_oplog footnote_descriptions1
        WHERE ((footnote_descriptions1.oid IN ( SELECT max(footnote_descriptions2.oid) AS max
                 FROM footnote_descriptions_oplog footnote_descriptions2
                WHERE ((footnote_descriptions1.footnote_description_period_sid = footnote_descriptions2.footnote_description_period_sid) AND ((footnote_descriptions1.footnote_id)::text = (footnote_descriptions2.footnote_id)::text) AND ((footnote_descriptions1.footnote_type_id)::text = (footnote_descriptions2.footnote_type_id)::text)))) AND ((footnote_descriptions1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW footnote_description_periods AS
       SELECT footnote_description_periods1.footnote_description_period_sid,
          footnote_description_periods1.footnote_type_id,
          footnote_description_periods1.footnote_id,
          footnote_description_periods1.validity_start_date,
          footnote_description_periods1.validity_end_date,
          footnote_description_periods1."national",
          footnote_description_periods1.oid,
          footnote_description_periods1.operation,
          footnote_description_periods1.operation_date
         FROM footnote_description_periods_oplog footnote_description_periods1
        WHERE ((footnote_description_periods1.oid IN ( SELECT max(footnote_description_periods2.oid) AS max
                 FROM footnote_description_periods_oplog footnote_description_periods2
                WHERE (((footnote_description_periods1.footnote_id)::text = (footnote_description_periods2.footnote_id)::text) AND ((footnote_description_periods1.footnote_type_id)::text = (footnote_description_periods2.footnote_type_id)::text) AND (footnote_description_periods1.footnote_description_period_sid = footnote_description_periods2.footnote_description_period_sid)))) AND ((footnote_description_periods1.operation)::text <> 'D'::text));
    }
  end
end
