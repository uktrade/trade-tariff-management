Sequel.migration do
  up do
    %w(
      certificates_oplog
      certificate_description_periods_oplog
      certificate_descriptions_oplog
    ).map do |table_name|
      add_column table_name, :added_by_id, Integer
      add_column table_name, :added_at, Time
    end

    run %Q{
      CREATE OR REPLACE VIEW public.certificates AS
       SELECT certificates1.certificate_type_code,
          certificates1.certificate_code,
          certificates1.validity_start_date,
          certificates1.validity_end_date,
          certificates1."national",
          certificates1.national_abbrev,
          certificates1.oid,
          certificates1.operation,
          certificates1.operation_date,
          certificates1.status,
          certificates1.workbasket_id,
          certificates1.workbasket_sequence_number,
          certificates1.added_by_id,
          certificates1.added_at
         FROM public.certificates_oplog certificates1
        WHERE ((certificates1.oid IN ( SELECT max(certificates2.oid) AS max
                 FROM public.certificates_oplog certificates2
                WHERE (((certificates1.certificate_code)::text = (certificates2.certificate_code)::text) AND ((certificates1.certificate_type_code)::text = (certificates2.certificate_type_code)::text)))) AND ((certificates1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW public.certificate_description_periods AS
       SELECT certificate_description_periods1.certificate_description_period_sid,
          certificate_description_periods1.certificate_type_code,
          certificate_description_periods1.certificate_code,
          certificate_description_periods1.validity_start_date,
          certificate_description_periods1.validity_end_date,
          certificate_description_periods1."national",
          certificate_description_periods1.oid,
          certificate_description_periods1.operation,
          certificate_description_periods1.operation_date,
          certificate_description_periods1.status,
          certificate_description_periods1.workbasket_id,
          certificate_description_periods1.workbasket_sequence_number,
          certificate_description_periods1.added_by_id,
          certificate_description_periods1.added_at
         FROM public.certificate_description_periods_oplog certificate_description_periods1
        WHERE ((certificate_description_periods1.oid IN ( SELECT max(certificate_description_periods2.oid) AS max
                 FROM public.certificate_description_periods_oplog certificate_description_periods2
                WHERE (certificate_description_periods1.certificate_description_period_sid = certificate_description_periods2.certificate_description_period_sid))) AND ((certificate_description_periods1.operation)::text <> 'D'::text));

    }

    run %Q{
      CREATE OR REPLACE VIEW public.certificate_descriptions AS
       SELECT certificate_descriptions1.certificate_description_period_sid,
          certificate_descriptions1.language_id,
          certificate_descriptions1.certificate_type_code,
          certificate_descriptions1.certificate_code,
          certificate_descriptions1.description,
          certificate_descriptions1."national",
          certificate_descriptions1.oid,
          certificate_descriptions1.operation,
          certificate_descriptions1.operation_date,
          certificate_descriptions1.status,
          certificate_descriptions1.workbasket_id,
          certificate_descriptions1.workbasket_sequence_number,
          certificate_descriptions1.added_by_id,
          certificate_descriptions1.added_at
         FROM public.certificate_descriptions_oplog certificate_descriptions1
        WHERE ((certificate_descriptions1.oid IN ( SELECT max(certificate_descriptions2.oid) AS max
                 FROM public.certificate_descriptions_oplog certificate_descriptions2
                WHERE (certificate_descriptions1.certificate_description_period_sid = certificate_descriptions2.certificate_description_period_sid))) AND ((certificate_descriptions1.operation)::text <> 'D'::text));
    }
  end

  down do
    run %Q{
      DROP VIEW public.certificates;

      CREATE OR REPLACE VIEW public.certificates AS
       SELECT certificates1.certificate_type_code,
          certificates1.certificate_code,
          certificates1.validity_start_date,
          certificates1.validity_end_date,
          certificates1."national",
          certificates1.national_abbrev,
          certificates1.oid,
          certificates1.operation,
          certificates1.operation_date,
          certificates1.status,
          certificates1.workbasket_id,
          certificates1.workbasket_sequence_number
         FROM public.certificates_oplog certificates1
        WHERE ((certificates1.oid IN ( SELECT max(certificates2.oid) AS max
                 FROM public.certificates_oplog certificates2
                WHERE (((certificates1.certificate_code)::text = (certificates2.certificate_code)::text) AND ((certificates1.certificate_type_code)::text = (certificates2.certificate_type_code)::text)))) AND ((certificates1.operation)::text <> 'D'::text));
    }

    run %Q{
      DROP VIEW public.certificate_description_periods;

      CREATE OR REPLACE VIEW public.certificate_description_periods AS
       SELECT certificate_description_periods1.certificate_description_period_sid,
          certificate_description_periods1.certificate_type_code,
          certificate_description_periods1.certificate_code,
          certificate_description_periods1.validity_start_date,
          certificate_description_periods1.validity_end_date,
          certificate_description_periods1."national",
          certificate_description_periods1.oid,
          certificate_description_periods1.operation,
          certificate_description_periods1.operation_date,
          certificate_description_periods1.status,
          certificate_description_periods1.workbasket_id,
          certificate_description_periods1.workbasket_sequence_number
         FROM public.certificate_description_periods_oplog certificate_description_periods1
        WHERE ((certificate_description_periods1.oid IN ( SELECT max(certificate_description_periods2.oid) AS max
                 FROM public.certificate_description_periods_oplog certificate_description_periods2
                WHERE (certificate_description_periods1.certificate_description_period_sid = certificate_description_periods2.certificate_description_period_sid))) AND ((certificate_description_periods1.operation)::text <> 'D'::text));

    }

    run %Q{
      DROP VIEW public.certificate_descriptions;

      CREATE OR REPLACE VIEW public.certificate_descriptions AS
       SELECT certificate_descriptions1.certificate_description_period_sid,
          certificate_descriptions1.language_id,
          certificate_descriptions1.certificate_type_code,
          certificate_descriptions1.certificate_code,
          certificate_descriptions1.description,
          certificate_descriptions1."national",
          certificate_descriptions1.oid,
          certificate_descriptions1.operation,
          certificate_descriptions1.operation_date,
          certificate_descriptions1.status,
          certificate_descriptions1.workbasket_id,
          certificate_descriptions1.workbasket_sequence_number
         FROM public.certificate_descriptions_oplog certificate_descriptions1
        WHERE ((certificate_descriptions1.oid IN ( SELECT max(certificate_descriptions2.oid) AS max
                 FROM public.certificate_descriptions_oplog certificate_descriptions2
                WHERE (certificate_descriptions1.certificate_description_period_sid = certificate_descriptions2.certificate_description_period_sid))) AND ((certificate_descriptions1.operation)::text <> 'D'::text));
    }

    %w(
      certificates_oplog
      certificate_description_periods_oplog
      certificate_descriptions_oplog
    ).map do |table_name|
      drop_column table_name, :added_by_id
      drop_column table_name, :added_at
    end
  end
end
