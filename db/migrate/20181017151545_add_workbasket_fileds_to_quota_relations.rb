Sequel.migration do
  up do
    %w(
      quota_suspension_periods_oplog
      quota_unsuspension_events_oplog
    ).map do |table_name|
      add_column table_name, :added_by_id, Integer
      add_column table_name, :added_at, Time
      add_column table_name, :national, :boolean
    end

    run %Q{
CREATE OR REPLACE VIEW quota_unsuspension_events AS
 SELECT quota_unsuspension_events1.quota_definition_sid,
    quota_unsuspension_events1.occurrence_timestamp,
    quota_unsuspension_events1.unsuspension_date,
    quota_unsuspension_events1.oid,
    quota_unsuspension_events1.operation,
    quota_unsuspension_events1.operation_date,
    quota_unsuspension_events1.status,
    quota_unsuspension_events1.workbasket_id,
    quota_unsuspension_events1.workbasket_sequence_number,
    quota_unsuspension_events1.added_by_id,
    quota_unsuspension_events1.added_at,
    quota_unsuspension_events1.national
   FROM quota_unsuspension_events_oplog quota_unsuspension_events1
  WHERE ((quota_unsuspension_events1.oid IN ( SELECT max(quota_unsuspension_events2.oid) AS max
           FROM quota_unsuspension_events_oplog quota_unsuspension_events2
          WHERE (quota_unsuspension_events1.quota_definition_sid = quota_unsuspension_events2.quota_definition_sid))) AND ((quota_unsuspension_events1.operation)::text <> 'D'::text));
    }

    run %Q{
CREATE OR REPLACE VIEW quota_suspension_periods AS
 SELECT quota_suspension_periods1.quota_suspension_period_sid,
    quota_suspension_periods1.quota_definition_sid,
    quota_suspension_periods1.suspension_start_date,
    quota_suspension_periods1.suspension_end_date,
    quota_suspension_periods1.description,
    quota_suspension_periods1.oid,
    quota_suspension_periods1.operation,
    quota_suspension_periods1.operation_date,
    quota_suspension_periods1.status,
    quota_suspension_periods1.workbasket_id,
    quota_suspension_periods1.workbasket_sequence_number,
    quota_suspension_periods1.added_by_id,
    quota_suspension_periods1.added_at,
    quota_suspension_periods1.national
   FROM quota_suspension_periods_oplog quota_suspension_periods1
  WHERE ((quota_suspension_periods1.oid IN ( SELECT max(quota_suspension_periods2.oid) AS max
           FROM quota_suspension_periods_oplog quota_suspension_periods2
          WHERE (quota_suspension_periods1.quota_suspension_period_sid = quota_suspension_periods2.quota_suspension_period_sid))) AND ((quota_suspension_periods1.operation)::text <> 'D'::text));
    }
  end

  down do
    run %Q{
CREATE OR REPLACE VIEW quota_unsuspension_events AS
 SELECT quota_unsuspension_events1.quota_definition_sid,
    quota_unsuspension_events1.occurrence_timestamp,
    quota_unsuspension_events1.unsuspension_date,
    quota_unsuspension_events1.oid,
    quota_unsuspension_events1.operation,
    quota_unsuspension_events1.operation_date,
    quota_unsuspension_events1.status,
    quota_unsuspension_events1.workbasket_id,
    quota_unsuspension_events1.workbasket_sequence_number
   FROM quota_unsuspension_events_oplog quota_unsuspension_events1
  WHERE ((quota_unsuspension_events1.oid IN ( SELECT max(quota_unsuspension_events2.oid) AS max
           FROM quota_unsuspension_events_oplog quota_unsuspension_events2
          WHERE (quota_unsuspension_events1.quota_definition_sid = quota_unsuspension_events2.quota_definition_sid))) AND ((quota_unsuspension_events1.operation)::text <> 'D'::text));
    }

    run %Q{
CREATE OR REPLACE VIEW quota_suspension_periods AS
 SELECT quota_suspension_periods1.quota_suspension_period_sid,
    quota_suspension_periods1.quota_definition_sid,
    quota_suspension_periods1.suspension_start_date,
    quota_suspension_periods1.suspension_end_date,
    quota_suspension_periods1.description,
    quota_suspension_periods1.oid,
    quota_suspension_periods1.operation,
    quota_suspension_periods1.operation_date,
    quota_suspension_periods1.status,
    quota_suspension_periods1.workbasket_id,
    quota_suspension_periods1.workbasket_sequence_number
   FROM quota_suspension_periods_oplog quota_suspension_periods1
  WHERE ((quota_suspension_periods1.oid IN ( SELECT max(quota_suspension_periods2.oid) AS max
           FROM quota_suspension_periods_oplog quota_suspension_periods2
          WHERE (quota_suspension_periods1.quota_suspension_period_sid = quota_suspension_periods2.quota_suspension_period_sid))) AND ((quota_suspension_periods1.operation)::text <> 'D'::text));
    }
  end
end
