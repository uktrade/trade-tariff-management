Sequel.migration do
  up do
    %w(
      geographical_areas_oplog
      geographical_area_descriptions_oplog
      geographical_area_description_periods_oplog
      geographical_area_memberships_oplog
    ).map do |table_name|
      add_column table_name, :added_by_id, Integer
      add_column table_name, :added_at, Time
    end

    run %Q{
      CREATE OR REPLACE VIEW public.geographical_areas AS
       SELECT geographical_areas1.geographical_area_sid,
          geographical_areas1.parent_geographical_area_group_sid,
          geographical_areas1.validity_start_date,
          geographical_areas1.validity_end_date,
          geographical_areas1.geographical_code,
          geographical_areas1.geographical_area_id,
          geographical_areas1."national",
          geographical_areas1.oid,
          geographical_areas1.operation,
          geographical_areas1.operation_date,
          geographical_areas1.status,
          geographical_areas1.workbasket_id,
          geographical_areas1.workbasket_sequence_number,
          geographical_areas1.added_by_id,
          geographical_areas1.added_at
         FROM public.geographical_areas_oplog geographical_areas1
        WHERE ((geographical_areas1.oid IN ( SELECT max(geographical_areas2.oid) AS max
                 FROM public.geographical_areas_oplog geographical_areas2
                WHERE (geographical_areas1.geographical_area_sid = geographical_areas2.geographical_area_sid))) AND ((geographical_areas1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW public.geographical_area_descriptions AS
       SELECT geographical_area_descriptions1.geographical_area_description_period_sid,
          geographical_area_descriptions1.language_id,
          geographical_area_descriptions1.geographical_area_sid,
          geographical_area_descriptions1.geographical_area_id,
          geographical_area_descriptions1.description,
          geographical_area_descriptions1."national",
          geographical_area_descriptions1.oid,
          geographical_area_descriptions1.operation,
          geographical_area_descriptions1.operation_date,
          geographical_area_descriptions1.status,
          geographical_area_descriptions1.workbasket_id,
          geographical_area_descriptions1.workbasket_sequence_number,
          geographical_area_descriptions1.added_by_id,
          geographical_area_descriptions1.added_at
         FROM public.geographical_area_descriptions_oplog geographical_area_descriptions1
        WHERE ((geographical_area_descriptions1.oid IN ( SELECT max(geographical_area_descriptions2.oid) AS max
                 FROM public.geographical_area_descriptions_oplog geographical_area_descriptions2
                WHERE ((geographical_area_descriptions1.geographical_area_description_period_sid = geographical_area_descriptions2.geographical_area_description_period_sid) AND (geographical_area_descriptions1.geographical_area_sid = geographical_area_descriptions2.geographical_area_sid)))) AND ((geographical_area_descriptions1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW public.geographical_area_description_periods AS
       SELECT geographical_area_description_periods1.geographical_area_description_period_sid,
          geographical_area_description_periods1.geographical_area_sid,
          geographical_area_description_periods1.validity_start_date,
          geographical_area_description_periods1.geographical_area_id,
          geographical_area_description_periods1.validity_end_date,
          geographical_area_description_periods1."national",
          geographical_area_description_periods1.oid,
          geographical_area_description_periods1.operation,
          geographical_area_description_periods1.operation_date,
          geographical_area_description_periods1.status,
          geographical_area_description_periods1.workbasket_id,
          geographical_area_description_periods1.workbasket_sequence_number,
          geographical_area_description_periods1.added_by_id,
          geographical_area_description_periods1.added_at
         FROM public.geographical_area_description_periods_oplog geographical_area_description_periods1
        WHERE ((geographical_area_description_periods1.oid IN ( SELECT max(geographical_area_description_periods2.oid) AS max
                 FROM public.geographical_area_description_periods_oplog geographical_area_description_periods2
                WHERE ((geographical_area_description_periods1.geographical_area_description_period_sid = geographical_area_description_periods2.geographical_area_description_period_sid) AND (geographical_area_description_periods1.geographical_area_sid = geographical_area_description_periods2.geographical_area_sid)))) AND ((geographical_area_description_periods1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW public.geographical_area_memberships AS
       SELECT geographical_area_memberships1.geographical_area_sid,
          geographical_area_memberships1.geographical_area_group_sid,
          geographical_area_memberships1.validity_start_date,
          geographical_area_memberships1.validity_end_date,
          geographical_area_memberships1."national",
          geographical_area_memberships1.oid,
          geographical_area_memberships1.operation,
          geographical_area_memberships1.operation_date,
          geographical_area_memberships1.status,
          geographical_area_memberships1.workbasket_id,
          geographical_area_memberships1.workbasket_sequence_number,
          geographical_area_memberships1.added_by_id,
          geographical_area_memberships1.added_at
         FROM public.geographical_area_memberships_oplog geographical_area_memberships1
        WHERE ((geographical_area_memberships1.oid IN ( SELECT max(geographical_area_memberships2.oid) AS max
                 FROM public.geographical_area_memberships_oplog geographical_area_memberships2
                WHERE ((geographical_area_memberships1.geographical_area_sid = geographical_area_memberships2.geographical_area_sid) AND (geographical_area_memberships1.geographical_area_group_sid = geographical_area_memberships2.geographical_area_group_sid) AND (geographical_area_memberships1.validity_start_date = geographical_area_memberships2.validity_start_date)))) AND ((geographical_area_memberships1.operation)::text <> 'D'::text));
    }
  end
end
