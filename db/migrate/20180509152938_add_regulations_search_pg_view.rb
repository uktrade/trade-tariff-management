Sequel.migration do
  up do
    run %Q{
      CREATE OR REPLACE VIEW regulations_search_pg_view AS
      SELECT concat_ws('_', oid, 'base_regulation') AS id,
             base_regulation_id AS regulation_id,
             base_regulation_role AS role,
             validity_start_date AS start_date,
             validity_end_date AS end_date,
             published_date AS published_date,
             officialjournal_number AS officialjournal_number,
             officialjournal_page AS officialjournal_page,
             created_at AS created_at,
             added_at AS added_at,
             added_by_id AS added_by_id
      FROM base_regulations_oplog
      UNION
      SELECT concat_ws('_', oid, 'modification_regulation') AS id,
             modification_regulation_id AS regulation_id,
             modification_regulation_role AS role,
             validity_start_date AS start_date,
             validity_end_date AS end_date,
             published_date AS published_date,
             officialjournal_number AS officialjournal_number,
             officialjournal_page AS officialjournal_page,
             created_at AS created_at,
             added_at AS added_at,
             added_by_id AS added_by_id
      FROM modification_regulations_oplog
      UNION
      SELECT concat_ws('_', oid, 'complete_abrogation_regulation') AS id,
             complete_abrogation_regulation_id AS regulation_id,
             complete_abrogation_regulation_role AS role,
             published_date AS start_date,
             NULL AS end_date,
             published_date AS published_date,
             officialjournal_number AS officialjournal_number,
             officialjournal_page AS officialjournal_page,
             created_at AS created_at,
             added_at AS added_at,
             added_by_id AS added_by_id
      FROM complete_abrogation_regulations_oplog
      UNION
      SELECT concat_ws('_', oid, 'explicit_abrogation_regulation') AS id,
             explicit_abrogation_regulation_id AS regulation_id,
             explicit_abrogation_regulation_role AS role,
             published_date AS start_date,
             NULL AS end_date,
             published_date AS published_date,
             officialjournal_number AS officialjournal_number,
             officialjournal_page AS officialjournal_page,
             created_at AS created_at,
             added_at AS added_at,
             added_by_id AS added_by_id
      FROM explicit_abrogation_regulations_oplog
      UNION
      SELECT concat_ws('_', oid, 'prorogation_regulation') AS id,
             prorogation_regulation_id AS regulation_id,
             prorogation_regulation_role AS role,
             published_date AS start_date,
             NULL AS end_date,
             published_date AS published_date,
             officialjournal_number AS officialjournal_number,
             officialjournal_page AS officialjournal_page,
             created_at AS created_at,
             added_at AS added_at,
             added_by_id AS added_by_id
      FROM prorogation_regulations_oplog
      UNION
      SELECT concat_ws('_', oid, 'full_temporary_stop_regulation') AS id,
             full_temporary_stop_regulation_id AS regulation_id,
             full_temporary_stop_regulation_role AS role,
             validity_start_date AS start_date,
             validity_end_date AS end_date,
             published_date AS published_date,
             officialjournal_number AS officialjournal_number,
             officialjournal_page AS officialjournal_page,
             created_at AS created_at,
             added_at AS added_at,
             added_by_id AS added_by_id
      FROM full_temporary_stop_regulations_oplog;
    }
  end

  down do
    run %Q{
      DROP VIEW regulations_search_pg_view;
    }
  end
end
