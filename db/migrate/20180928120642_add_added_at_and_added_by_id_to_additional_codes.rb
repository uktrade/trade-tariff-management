Sequel.migration do
  up do
    %w(
      additional_codes_oplog
      additional_code_descriptions_oplog
      additional_code_description_periods_oplog
      meursing_additional_codes_oplog
    ).map do |table_name|
      add_column table_name, :added_by_id, Integer
      add_column table_name, :added_at, Time
    end

    %w(
      additional_code_description_periods_oplog
      meursing_additional_codes_oplog
    ).map do |table_name|
      add_column table_name, :national, :boolean
    end

    run %Q{
CREATE OR REPLACE VIEW public.additional_codes AS
 SELECT additional_codes1.additional_code_sid,
    additional_codes1.additional_code_type_id,
    additional_codes1.additional_code,
    additional_codes1.validity_start_date,
    additional_codes1.validity_end_date,
    additional_codes1."national",
    additional_codes1.oid,
    additional_codes1.operation,
    additional_codes1.operation_date,
    additional_codes1.status,
    additional_codes1.workbasket_id,
    additional_codes1.workbasket_sequence_number,
    additional_codes1.added_by_id,
    additional_codes1.added_at
   FROM public.additional_codes_oplog additional_codes1
  WHERE ((additional_codes1.oid IN ( SELECT max(additional_codes2.oid) AS max
           FROM public.additional_codes_oplog additional_codes2
          WHERE (additional_codes1.additional_code_sid = additional_codes2.additional_code_sid))) AND ((additional_codes1.operation)::text <> 'D'::text));
    }

    run %Q{
CREATE OR REPLACE VIEW public.additional_code_descriptions AS
 SELECT additional_code_descriptions1.additional_code_description_period_sid,
    additional_code_descriptions1.language_id,
    additional_code_descriptions1.additional_code_sid,
    additional_code_descriptions1.additional_code_type_id,
    additional_code_descriptions1.additional_code,
    additional_code_descriptions1.description,
    additional_code_descriptions1."national",
    additional_code_descriptions1.oid,
    additional_code_descriptions1.operation,
    additional_code_descriptions1.operation_date,
    additional_code_descriptions1.status,
    additional_code_descriptions1.workbasket_id,
    additional_code_descriptions1.workbasket_sequence_number,
    additional_code_descriptions1.added_by_id,
    additional_code_descriptions1.added_at
   FROM public.additional_code_descriptions_oplog additional_code_descriptions1
  WHERE ((additional_code_descriptions1.oid IN ( SELECT max(additional_code_descriptions2.oid) AS max
           FROM public.additional_code_descriptions_oplog additional_code_descriptions2
          WHERE ((additional_code_descriptions1.additional_code_description_period_sid = additional_code_descriptions2.additional_code_description_period_sid) AND (additional_code_descriptions1.additional_code_sid = additional_code_descriptions2.additional_code_sid)))) AND ((additional_code_descriptions1.operation)::text <> 'D'::text));
    }

    run %Q{
CREATE OR REPLACE VIEW public.additional_code_description_periods AS
 SELECT additional_code_description_periods1.additional_code_description_period_sid,
    additional_code_description_periods1.additional_code_sid,
    additional_code_description_periods1.additional_code_type_id,
    additional_code_description_periods1.additional_code,
    additional_code_description_periods1.validity_start_date,
    additional_code_description_periods1.validity_end_date,
    additional_code_description_periods1.oid,
    additional_code_description_periods1.operation,
    additional_code_description_periods1.operation_date,
    additional_code_description_periods1.status,
    additional_code_description_periods1.workbasket_id,
    additional_code_description_periods1.workbasket_sequence_number,
    additional_code_description_periods1.added_by_id,
    additional_code_description_periods1.added_at,
    additional_code_description_periods1."national"
   FROM public.additional_code_description_periods_oplog additional_code_description_periods1
  WHERE ((additional_code_description_periods1.oid IN ( SELECT max(additional_code_description_periods2.oid) AS max
           FROM public.additional_code_description_periods_oplog additional_code_description_periods2
          WHERE ((additional_code_description_periods1.additional_code_description_period_sid = additional_code_description_periods2.additional_code_description_period_sid) AND (additional_code_description_periods1.additional_code_sid = additional_code_description_periods2.additional_code_sid) AND ((additional_code_description_periods1.additional_code_type_id)::text = (additional_code_description_periods2.additional_code_type_id)::text)))) AND ((additional_code_description_periods1.operation)::text <> 'D'::text));
    }

    run %Q{
CREATE OR REPLACE VIEW public.meursing_additional_codes AS
 SELECT meursing_additional_codes1.meursing_additional_code_sid,
    meursing_additional_codes1.additional_code,
    meursing_additional_codes1.validity_start_date,
    meursing_additional_codes1.validity_end_date,
    meursing_additional_codes1.oid,
    meursing_additional_codes1.operation,
    meursing_additional_codes1.operation_date,
    meursing_additional_codes1.status,
    meursing_additional_codes1.workbasket_id,
    meursing_additional_codes1.workbasket_sequence_number,
    meursing_additional_codes1.added_by_id,
    meursing_additional_codes1.added_at,
    meursing_additional_codes1."national"
   FROM public.meursing_additional_codes_oplog meursing_additional_codes1
  WHERE ((meursing_additional_codes1.oid IN ( SELECT max(meursing_additional_codes2.oid) AS max
           FROM public.meursing_additional_codes_oplog meursing_additional_codes2
          WHERE (meursing_additional_codes1.meursing_additional_code_sid = meursing_additional_codes2.meursing_additional_code_sid))) AND ((meursing_additional_codes1.operation)::text <> 'D'::text));
    }
  end

  down do
    %w(
      additional_codes_oplog
      additional_code_descriptions_oplog
      additional_code_description_periods_oplog
      meursing_additional_codes_oplog
    ).map do |table_name|
      run "DROP VIEW public.#{table_name.gsub('_oplog', '')}"
      drop_column table_name, :added_by_id
      drop_column table_name, :added_at
    end

    %w(
      additional_code_description_periods_oplog
      meursing_additional_codes_oplog
    ).map do |table_name|
      drop_column table_name, :national
    end

    run %Q{
CREATE OR REPLACE VIEW public.additional_codes AS
 SELECT additional_codes1.additional_code_sid,
    additional_codes1.additional_code_type_id,
    additional_codes1.additional_code,
    additional_codes1.validity_start_date,
    additional_codes1.validity_end_date,
    additional_codes1."national",
    additional_codes1.oid,
    additional_codes1.operation,
    additional_codes1.operation_date,
    additional_codes1.status,
    additional_codes1.workbasket_id,
    additional_codes1.workbasket_sequence_number
   FROM public.additional_codes_oplog additional_codes1
  WHERE ((additional_codes1.oid IN ( SELECT max(additional_codes2.oid) AS max
           FROM public.additional_codes_oplog additional_codes2
          WHERE (additional_codes1.additional_code_sid = additional_codes2.additional_code_sid))) AND ((additional_codes1.operation)::text <> 'D'::text));
    }

    run %Q{
CREATE OR REPLACE VIEW public.additional_code_descriptions AS
 SELECT additional_code_descriptions1.additional_code_description_period_sid,
    additional_code_descriptions1.language_id,
    additional_code_descriptions1.additional_code_sid,
    additional_code_descriptions1.additional_code_type_id,
    additional_code_descriptions1.additional_code,
    additional_code_descriptions1.description,
    additional_code_descriptions1."national",
    additional_code_descriptions1.oid,
    additional_code_descriptions1.operation,
    additional_code_descriptions1.operation_date,
    additional_code_descriptions1.status,
    additional_code_descriptions1.workbasket_id,
    additional_code_descriptions1.workbasket_sequence_number
   FROM public.additional_code_descriptions_oplog additional_code_descriptions1
  WHERE ((additional_code_descriptions1.oid IN ( SELECT max(additional_code_descriptions2.oid) AS max
           FROM public.additional_code_descriptions_oplog additional_code_descriptions2
          WHERE ((additional_code_descriptions1.additional_code_description_period_sid = additional_code_descriptions2.additional_code_description_period_sid) AND (additional_code_descriptions1.additional_code_sid = additional_code_descriptions2.additional_code_sid)))) AND ((additional_code_descriptions1.operation)::text <> 'D'::text));
    }

    run %Q{
CREATE OR REPLACE VIEW public.additional_code_description_periods AS
 SELECT additional_code_description_periods1.additional_code_description_period_sid,
    additional_code_description_periods1.additional_code_sid,
    additional_code_description_periods1.additional_code_type_id,
    additional_code_description_periods1.additional_code,
    additional_code_description_periods1.validity_start_date,
    additional_code_description_periods1.validity_end_date,
    additional_code_description_periods1.oid,
    additional_code_description_periods1.operation,
    additional_code_description_periods1.operation_date,
    additional_code_description_periods1.status,
    additional_code_description_periods1.workbasket_id,
    additional_code_description_periods1.workbasket_sequence_number
   FROM public.additional_code_description_periods_oplog additional_code_description_periods1
  WHERE ((additional_code_description_periods1.oid IN ( SELECT max(additional_code_description_periods2.oid) AS max
           FROM public.additional_code_description_periods_oplog additional_code_description_periods2
          WHERE ((additional_code_description_periods1.additional_code_description_period_sid = additional_code_description_periods2.additional_code_description_period_sid) AND (additional_code_description_periods1.additional_code_sid = additional_code_description_periods2.additional_code_sid) AND ((additional_code_description_periods1.additional_code_type_id)::text = (additional_code_description_periods2.additional_code_type_id)::text)))) AND ((additional_code_description_periods1.operation)::text <> 'D'::text));
    }

    run %Q{
CREATE OR REPLACE VIEW public.meursing_additional_codes AS
 SELECT meursing_additional_codes1.meursing_additional_code_sid,
    meursing_additional_codes1.additional_code,
    meursing_additional_codes1.validity_start_date,
    meursing_additional_codes1.validity_end_date,
    meursing_additional_codes1.oid,
    meursing_additional_codes1.operation,
    meursing_additional_codes1.operation_date,
    meursing_additional_codes1.status,
    meursing_additional_codes1.workbasket_id,
    meursing_additional_codes1.workbasket_sequence_number
   FROM public.meursing_additional_codes_oplog meursing_additional_codes1
  WHERE ((meursing_additional_codes1.oid IN ( SELECT max(meursing_additional_codes2.oid) AS max
           FROM public.meursing_additional_codes_oplog meursing_additional_codes2
          WHERE (meursing_additional_codes1.meursing_additional_code_sid = meursing_additional_codes2.meursing_additional_code_sid))) AND ((meursing_additional_codes1.operation)::text <> 'D'::text));
    }

  end
end
