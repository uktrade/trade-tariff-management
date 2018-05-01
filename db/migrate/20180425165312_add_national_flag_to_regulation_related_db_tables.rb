Sequel.migration do
  up do
    %w(
      modification_regulations_oplog
      complete_abrogation_regulations_oplog
      explicit_abrogation_regulations_oplog
      prorogation_regulations_oplog
      full_temporary_stop_regulations_oplog
    ).map do |table_name|
      add_column table_name, :national, :boolean
    end

    run %Q{
      CREATE OR REPLACE VIEW modification_regulations AS
       SELECT modification_regulations1.modification_regulation_role,
          modification_regulations1.modification_regulation_id,
          modification_regulations1.validity_start_date,
          modification_regulations1.validity_end_date,
          modification_regulations1.published_date,
          modification_regulations1.officialjournal_number,
          modification_regulations1.officialjournal_page,
          modification_regulations1.base_regulation_role,
          modification_regulations1.base_regulation_id,
          modification_regulations1.replacement_indicator,
          modification_regulations1.stopped_flag,
          modification_regulations1.information_text,
          modification_regulations1.approved_flag,
          modification_regulations1.explicit_abrogation_regulation_role,
          modification_regulations1.explicit_abrogation_regulation_id,
          modification_regulations1.effective_end_date,
          modification_regulations1.complete_abrogation_regulation_role,
          modification_regulations1.complete_abrogation_regulation_id,
          modification_regulations1.oid,
          modification_regulations1.operation,
          modification_regulations1.operation_date,
          modification_regulations1.added_by_id,
          modification_regulations1.added_at,
          modification_regulations1.national
         FROM modification_regulations_oplog modification_regulations1
        WHERE ((modification_regulations1.oid IN ( SELECT max(modification_regulations2.oid) AS max
                 FROM modification_regulations_oplog modification_regulations2
                WHERE (((modification_regulations1.modification_regulation_id)::text = (modification_regulations2.modification_regulation_id)::text) AND (modification_regulations1.modification_regulation_role = modification_regulations2.modification_regulation_role)))) AND ((modification_regulations1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW complete_abrogation_regulations AS
       SELECT complete_abrogation_regulations1.complete_abrogation_regulation_role,
          complete_abrogation_regulations1.complete_abrogation_regulation_id,
          complete_abrogation_regulations1.published_date,
          complete_abrogation_regulations1.officialjournal_number,
          complete_abrogation_regulations1.officialjournal_page,
          complete_abrogation_regulations1.replacement_indicator,
          complete_abrogation_regulations1.information_text,
          complete_abrogation_regulations1.approved_flag,
          complete_abrogation_regulations1.oid,
          complete_abrogation_regulations1.operation,
          complete_abrogation_regulations1.operation_date,
          complete_abrogation_regulations1.added_by_id,
          complete_abrogation_regulations1.added_at,
          complete_abrogation_regulations1.national
         FROM complete_abrogation_regulations_oplog complete_abrogation_regulations1
        WHERE ((complete_abrogation_regulations1.oid IN ( SELECT max(complete_abrogation_regulations2.oid) AS max
                 FROM complete_abrogation_regulations_oplog complete_abrogation_regulations2
                WHERE (((complete_abrogation_regulations1.complete_abrogation_regulation_id)::text = (complete_abrogation_regulations2.complete_abrogation_regulation_id)::text) AND (complete_abrogation_regulations1.complete_abrogation_regulation_role = complete_abrogation_regulations2.complete_abrogation_regulation_role)))) AND ((complete_abrogation_regulations1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW explicit_abrogation_regulations AS
       SELECT explicit_abrogation_regulations1.explicit_abrogation_regulation_role,
          explicit_abrogation_regulations1.explicit_abrogation_regulation_id,
          explicit_abrogation_regulations1.published_date,
          explicit_abrogation_regulations1.officialjournal_number,
          explicit_abrogation_regulations1.officialjournal_page,
          explicit_abrogation_regulations1.replacement_indicator,
          explicit_abrogation_regulations1.abrogation_date,
          explicit_abrogation_regulations1.information_text,
          explicit_abrogation_regulations1.approved_flag,
          explicit_abrogation_regulations1.oid,
          explicit_abrogation_regulations1.operation,
          explicit_abrogation_regulations1.operation_date,
          explicit_abrogation_regulations1.added_by_id,
          explicit_abrogation_regulations1.added_at,
          explicit_abrogation_regulations1.national
         FROM explicit_abrogation_regulations_oplog explicit_abrogation_regulations1
        WHERE ((explicit_abrogation_regulations1.oid IN ( SELECT max(explicit_abrogation_regulations2.oid) AS max
                 FROM explicit_abrogation_regulations_oplog explicit_abrogation_regulations2
                WHERE (((explicit_abrogation_regulations1.explicit_abrogation_regulation_id)::text = (explicit_abrogation_regulations2.explicit_abrogation_regulation_id)::text) AND (explicit_abrogation_regulations1.explicit_abrogation_regulation_role = explicit_abrogation_regulations2.explicit_abrogation_regulation_role)))) AND ((explicit_abrogation_regulations1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW prorogation_regulations AS
       SELECT prorogation_regulations1.prorogation_regulation_role,
          prorogation_regulations1.prorogation_regulation_id,
          prorogation_regulations1.published_date,
          prorogation_regulations1.officialjournal_number,
          prorogation_regulations1.officialjournal_page,
          prorogation_regulations1.replacement_indicator,
          prorogation_regulations1.information_text,
          prorogation_regulations1.approved_flag,
          prorogation_regulations1.oid,
          prorogation_regulations1.operation,
          prorogation_regulations1.operation_date,
          prorogation_regulations1.added_by_id,
          prorogation_regulations1.added_at,
          prorogation_regulations1.national
         FROM prorogation_regulations_oplog prorogation_regulations1
        WHERE ((prorogation_regulations1.oid IN ( SELECT max(prorogation_regulations2.oid) AS max
                 FROM prorogation_regulations_oplog prorogation_regulations2
                WHERE (((prorogation_regulations1.prorogation_regulation_id)::text = (prorogation_regulations2.prorogation_regulation_id)::text) AND (prorogation_regulations1.prorogation_regulation_role = prorogation_regulations2.prorogation_regulation_role)))) AND ((prorogation_regulations1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW full_temporary_stop_regulations AS
       SELECT full_temporary_stop_regulations1.full_temporary_stop_regulation_role,
          full_temporary_stop_regulations1.full_temporary_stop_regulation_id,
          full_temporary_stop_regulations1.published_date,
          full_temporary_stop_regulations1.officialjournal_number,
          full_temporary_stop_regulations1.officialjournal_page,
          full_temporary_stop_regulations1.validity_start_date,
          full_temporary_stop_regulations1.validity_end_date,
          full_temporary_stop_regulations1.effective_enddate,
          full_temporary_stop_regulations1.explicit_abrogation_regulation_role,
          full_temporary_stop_regulations1.explicit_abrogation_regulation_id,
          full_temporary_stop_regulations1.replacement_indicator,
          full_temporary_stop_regulations1.information_text,
          full_temporary_stop_regulations1.approved_flag,
          full_temporary_stop_regulations1.oid,
          full_temporary_stop_regulations1.operation,
          full_temporary_stop_regulations1.operation_date,
          full_temporary_stop_regulations1.added_by_id,
          full_temporary_stop_regulations1.added_at,
          full_temporary_stop_regulations1.national
         FROM full_temporary_stop_regulations_oplog full_temporary_stop_regulations1
        WHERE ((full_temporary_stop_regulations1.oid IN ( SELECT max(full_temporary_stop_regulations2.oid) AS max
                 FROM full_temporary_stop_regulations_oplog full_temporary_stop_regulations2
                WHERE (((full_temporary_stop_regulations1.full_temporary_stop_regulation_id)::text = (full_temporary_stop_regulations2.full_temporary_stop_regulation_id)::text) AND (full_temporary_stop_regulations1.full_temporary_stop_regulation_role = full_temporary_stop_regulations2.full_temporary_stop_regulation_role)))) AND ((full_temporary_stop_regulations1.operation)::text <> 'D'::text));
    }
  end

  down do
    %w(
      modification_regulations_oplog
      complete_abrogation_regulations_oplog
      explicit_abrogation_regulations_oplog
      prorogation_regulations_oplog
      full_temporary_stop_regulations_oplog
    ).map do |table_name|
      drop_column table_name, :national
    end

    run %Q{
      CREATE OR REPLACE VIEW modification_regulations AS
       SELECT modification_regulations1.modification_regulation_role,
          modification_regulations1.modification_regulation_id,
          modification_regulations1.validity_start_date,
          modification_regulations1.validity_end_date,
          modification_regulations1.published_date,
          modification_regulations1.officialjournal_number,
          modification_regulations1.officialjournal_page,
          modification_regulations1.base_regulation_role,
          modification_regulations1.base_regulation_id,
          modification_regulations1.replacement_indicator,
          modification_regulations1.stopped_flag,
          modification_regulations1.information_text,
          modification_regulations1.approved_flag,
          modification_regulations1.explicit_abrogation_regulation_role,
          modification_regulations1.explicit_abrogation_regulation_id,
          modification_regulations1.effective_end_date,
          modification_regulations1.complete_abrogation_regulation_role,
          modification_regulations1.complete_abrogation_regulation_id,
          modification_regulations1.oid,
          modification_regulations1.operation,
          modification_regulations1.operation_date,
          modification_regulations1.added_by_id,
          modification_regulations1.added_at
         FROM modification_regulations_oplog modification_regulations1
        WHERE ((modification_regulations1.oid IN ( SELECT max(modification_regulations2.oid) AS max
                 FROM modification_regulations_oplog modification_regulations2
                WHERE (((modification_regulations1.modification_regulation_id)::text = (modification_regulations2.modification_regulation_id)::text) AND (modification_regulations1.modification_regulation_role = modification_regulations2.modification_regulation_role)))) AND ((modification_regulations1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW complete_abrogation_regulations AS
       SELECT complete_abrogation_regulations1.complete_abrogation_regulation_role,
          complete_abrogation_regulations1.complete_abrogation_regulation_id,
          complete_abrogation_regulations1.published_date,
          complete_abrogation_regulations1.officialjournal_number,
          complete_abrogation_regulations1.officialjournal_page,
          complete_abrogation_regulations1.replacement_indicator,
          complete_abrogation_regulations1.information_text,
          complete_abrogation_regulations1.approved_flag,
          complete_abrogation_regulations1.oid,
          complete_abrogation_regulations1.operation,
          complete_abrogation_regulations1.operation_date,
          complete_abrogation_regulations1.added_by_id,
          complete_abrogation_regulations1.added_at
         FROM complete_abrogation_regulations_oplog complete_abrogation_regulations1
        WHERE ((complete_abrogation_regulations1.oid IN ( SELECT max(complete_abrogation_regulations2.oid) AS max
                 FROM complete_abrogation_regulations_oplog complete_abrogation_regulations2
                WHERE (((complete_abrogation_regulations1.complete_abrogation_regulation_id)::text = (complete_abrogation_regulations2.complete_abrogation_regulation_id)::text) AND (complete_abrogation_regulations1.complete_abrogation_regulation_role = complete_abrogation_regulations2.complete_abrogation_regulation_role)))) AND ((complete_abrogation_regulations1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW explicit_abrogation_regulations AS
       SELECT explicit_abrogation_regulations1.explicit_abrogation_regulation_role,
          explicit_abrogation_regulations1.explicit_abrogation_regulation_id,
          explicit_abrogation_regulations1.published_date,
          explicit_abrogation_regulations1.officialjournal_number,
          explicit_abrogation_regulations1.officialjournal_page,
          explicit_abrogation_regulations1.replacement_indicator,
          explicit_abrogation_regulations1.abrogation_date,
          explicit_abrogation_regulations1.information_text,
          explicit_abrogation_regulations1.approved_flag,
          explicit_abrogation_regulations1.oid,
          explicit_abrogation_regulations1.operation,
          explicit_abrogation_regulations1.operation_date,
          explicit_abrogation_regulations1.added_by_id,
          explicit_abrogation_regulations1.added_at
         FROM explicit_abrogation_regulations_oplog explicit_abrogation_regulations1
        WHERE ((explicit_abrogation_regulations1.oid IN ( SELECT max(explicit_abrogation_regulations2.oid) AS max
                 FROM explicit_abrogation_regulations_oplog explicit_abrogation_regulations2
                WHERE (((explicit_abrogation_regulations1.explicit_abrogation_regulation_id)::text = (explicit_abrogation_regulations2.explicit_abrogation_regulation_id)::text) AND (explicit_abrogation_regulations1.explicit_abrogation_regulation_role = explicit_abrogation_regulations2.explicit_abrogation_regulation_role)))) AND ((explicit_abrogation_regulations1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW prorogation_regulations AS
       SELECT prorogation_regulations1.prorogation_regulation_role,
          prorogation_regulations1.prorogation_regulation_id,
          prorogation_regulations1.published_date,
          prorogation_regulations1.officialjournal_number,
          prorogation_regulations1.officialjournal_page,
          prorogation_regulations1.replacement_indicator,
          prorogation_regulations1.information_text,
          prorogation_regulations1.approved_flag,
          prorogation_regulations1.oid,
          prorogation_regulations1.operation,
          prorogation_regulations1.operation_date,
          prorogation_regulations1.added_by_id,
          prorogation_regulations1.added_at
         FROM prorogation_regulations_oplog prorogation_regulations1
        WHERE ((prorogation_regulations1.oid IN ( SELECT max(prorogation_regulations2.oid) AS max
                 FROM prorogation_regulations_oplog prorogation_regulations2
                WHERE (((prorogation_regulations1.prorogation_regulation_id)::text = (prorogation_regulations2.prorogation_regulation_id)::text) AND (prorogation_regulations1.prorogation_regulation_role = prorogation_regulations2.prorogation_regulation_role)))) AND ((prorogation_regulations1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW full_temporary_stop_regulations AS
       SELECT full_temporary_stop_regulations1.full_temporary_stop_regulation_role,
          full_temporary_stop_regulations1.full_temporary_stop_regulation_id,
          full_temporary_stop_regulations1.published_date,
          full_temporary_stop_regulations1.officialjournal_number,
          full_temporary_stop_regulations1.officialjournal_page,
          full_temporary_stop_regulations1.validity_start_date,
          full_temporary_stop_regulations1.validity_end_date,
          full_temporary_stop_regulations1.effective_enddate,
          full_temporary_stop_regulations1.explicit_abrogation_regulation_role,
          full_temporary_stop_regulations1.explicit_abrogation_regulation_id,
          full_temporary_stop_regulations1.replacement_indicator,
          full_temporary_stop_regulations1.information_text,
          full_temporary_stop_regulations1.approved_flag,
          full_temporary_stop_regulations1.oid,
          full_temporary_stop_regulations1.operation,
          full_temporary_stop_regulations1.operation_date,
          full_temporary_stop_regulations1.added_by_id,
          full_temporary_stop_regulations1.added_at
         FROM full_temporary_stop_regulations_oplog full_temporary_stop_regulations1
        WHERE ((full_temporary_stop_regulations1.oid IN ( SELECT max(full_temporary_stop_regulations2.oid) AS max
                 FROM full_temporary_stop_regulations_oplog full_temporary_stop_regulations2
                WHERE (((full_temporary_stop_regulations1.full_temporary_stop_regulation_id)::text = (full_temporary_stop_regulations2.full_temporary_stop_regulation_id)::text) AND (full_temporary_stop_regulations1.full_temporary_stop_regulation_role = full_temporary_stop_regulations2.full_temporary_stop_regulation_role)))) AND ((full_temporary_stop_regulations1.operation)::text <> 'D'::text));
    }
  end
end
