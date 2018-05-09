Sequel.migration do
  up do
    run %Q{
      CREATE OR REPLACE VIEW regulations_search_pg_view AS
      SELECT concat_ws('-',`base_regulations_oplog`.`oid`,'base_regulation') AS `id`,
             `base_regulations_oplog`.`base_regulation_id` AS `regulation_id`,
             `base_regulations_oplog`.`base_regulation_role` AS `role`,
             `base_regulations_oplog`.`validity_start_date` AS `start_date`,
             `base_regulations_oplog`.`validity_end_date` AS `end_date`,
             `base_regulations_oplog`.`published_date` AS `published_date`,
             `base_regulations_oplog`.`officialjournal_number` AS `officialjournal_number`,
             `base_regulations_oplog`.`officialjournal_page` AS `officialjournal_page`,
             `base_regulations_oplog`.`created_at` AS `created_at`,
             `base_regulations_oplog`.`added_at` AS `added_at`,
             `base_regulations_oplog`.`added_by_id` AS `added_by_id`
      FROM `base_regulations_oplog`
      UNION
      SELECT concat_ws('-',`modification_regulations_oplog`.`oid`,'modification_regulation') AS `id`,
             `modification_regulations_oplog`.`modification_regulation_id` AS `regulation_id`,
             `modification_regulations_oplog`.`modification_regulation_role` AS `role`,
             `modification_regulations_oplog`.`validity_start_date` AS `start_date`,
             `modification_regulations_oplog`.`validity_end_date` AS `end_date`,
             `modification_regulations_oplog`.`published_date` AS `published_date`,
             `modification_regulations_oplog`.`officialjournal_number` AS `officialjournal_number`,
             `modification_regulations_oplog`.`officialjournal_page` AS `officialjournal_page`,
             `modification_regulations_oplog`.`created_at` AS `created_at`,
             `modification_regulations_oplog`.`added_at` AS `added_at`,
             `modification_regulations_oplog`.`added_by_id` AS `added_by_id`
      FROM `modification_regulations_oplog`
      UNION
      SELECT concat_ws('-',`complete_abrogation_regulations_oplog`.`oid`,'complete_abrogation_regulation') AS `id`,
             `complete_abrogation_regulations_oplog`.`complete_abrogation_regulation_id` AS `regulation_id`,
             `complete_abrogation_regulations_oplog`.`complete_abrogation_regulation_role` AS `role`,
             `complete_abrogation_regulations_oplog`.`published_date` AS `start_date`,
             NULL AS `end_date`,
             `complete_abrogation_regulations_oplog`.`published_date` AS `published_date`,
             `complete_abrogation_regulations_oplog`.`officialjournal_number` AS `officialjournal_number`,
             `complete_abrogation_regulations_oplog`.`officialjournal_page` AS `officialjournal_page`,
             `complete_abrogation_regulations_oplog`.`created_at` AS `created_at`,
             `complete_abrogation_regulations_oplog`.`added_at` AS `added_at`,
             `complete_abrogation_regulations_oplog`.`added_by_id` AS `added_by_id`
      FROM `complete_abrogation_regulations_oplog`
      UNION
      SELECT concat_ws('-',`explicit_abrogation_regulations_oplog`.`oid`,'explicit_abrogation_regulation') AS `id`,
             `explicit_abrogation_regulations_oplog`.`explicit_abrogation_regulation_id` AS `regulation_id`,
             `explicit_abrogation_regulations_oplog`.`explicit_abrogation_regulation_role` AS `role`,
             `explicit_abrogation_regulations_oplog`.`published_date` AS `start_date`,
             NULL AS `end_date`,
             `explicit_abrogation_regulations_oplog`.`published_date` AS `published_date`,
             `explicit_abrogation_regulations_oplog`.`officialjournal_number` AS `officialjournal_number`,
             `explicit_abrogation_regulations_oplog`.`officialjournal_page` AS `officialjournal_page`,
             `explicit_abrogation_regulations_oplog`.`created_at` AS `created_at`,
             `explicit_abrogation_regulations_oplog`.`added_at` AS `added_at`,
             `explicit_abrogation_regulations_oplog`.`added_by_id` AS `added_by_id`
      FROM `explicit_abrogation_regulations_oplog`
      UNION
      SELECT concat_ws('-',`prorogation_regulations_oplog`.`oid`,'prorogation_regulation') AS `id`,
             `prorogation_regulations_oplog`.`prorogation_regulation_id` AS `regulation_id`,
             `prorogation_regulations_oplog`.`prorogation_regulation_role` AS `role`,
             `prorogation_regulations_oplog`.`published_date` AS `start_date`,
             NULL AS `end_date`,
             `prorogation_regulations_oplog`.`published_date` AS `published_date`,
             `prorogation_regulations_oplog`.`officialjournal_number` AS `officialjournal_number`,
             `prorogation_regulations_oplog`.`officialjournal_page` AS `officialjournal_page`,
             `prorogation_regulations_oplog`.`created_at` AS `created_at`,
             `prorogation_regulations_oplog`.`added_at` AS `added_at`,
             `prorogation_regulations_oplog`.`added_by_id` AS `added_by_id`
      FROM `prorogation_regulations_oplog`
      UNION
      SELECT concat_ws('-',`full_temporary_stop_regulations_oplog`.`oid`,'full_temporary_stop_regulation') AS `id`,
             `full_temporary_stop_regulations_oplog`.`full_temporary_stop_regulation_id` AS `regulation_id`,
             `full_temporary_stop_regulations_oplog`.`full_temporary_stop_regulation_role` AS `role`,
             `full_temporary_stop_regulations_oplog`.`validity_start_date` AS `start_date`,
             `full_temporary_stop_regulations_oplog`.`validity_end_date` AS `end_date`,
             `full_temporary_stop_regulations_oplog`.`published_date` AS `published_date`,
             `full_temporary_stop_regulations_oplog`.`officialjournal_number` AS `officialjournal_number`,
             `full_temporary_stop_regulations_oplog`.`officialjournal_page` AS `officialjournal_page`,
             `full_temporary_stop_regulations_oplog`.`created_at` AS `created_at`,
             `full_temporary_stop_regulations_oplog`.`added_at` AS `added_at`,
             `full_temporary_stop_regulations_oplog`.`added_by_id` AS `added_by_id`
      FROM `full_temporary_stop_regulations_oplog`;
    }
  end

  down do
    run %Q{
      DROP VIEW regulations_search_pg_view;
    }
  end
end
