Sequel.migration do
  up do
    run %Q{
DROP VIEW all_additional_codes;
CREATE OR REPLACE VIEW all_additional_codes AS
 SELECT meursing_additional_codes.meursing_additional_code_sid AS additional_code_sid,
    '7'::character varying AS additional_code_type_id,
    meursing_additional_codes.additional_code,
    NULL::text AS description,
    NULL::character varying AS language_id,
    meursing_additional_codes.validity_start_date,
    meursing_additional_codes.validity_end_date,
    meursing_additional_codes.operation_date,
    meursing_additional_codes.status,
    meursing_additional_codes.workbasket_id,
    meursing_additional_codes.added_by_id,
    meursing_additional_codes.added_at,
    meursing_additional_codes."national"
   FROM public.meursing_additional_codes
UNION
 SELECT additional_codes.additional_code_sid,
       additional_codes.additional_code_type_id,
       additional_codes.additional_code,
       additional_code_descriptions.description,
       additional_code_descriptions.language_id,
       additional_codes.validity_start_date,
       additional_codes.validity_end_date,
       additional_codes.operation_date,
       additional_codes.status,
       additional_codes.workbasket_id,
       additional_codes.added_by_id,
       additional_codes.added_at,
       additional_codes."national"
FROM additional_codes

INNER JOIN (
    SELECT *
    FROM additional_code_description_periods
    WHERE additional_code_description_period_sid IN (
        SELECT MAX(additional_code_description_period_sid)
        FROM additional_code_description_periods
        GROUP BY (additional_code_type_id, additional_code)
    )) as additional_code_description_periods

    ON ((additional_code_description_periods.additional_code_sid = additional_codes.additional_code_sid) AND
           ((additional_code_description_periods.additional_code_type_id) :: text =
            (additional_codes.additional_code_type_id) :: text) AND
           ((additional_code_description_periods.additional_code) :: text =
            (additional_codes.additional_code) :: text))

INNER JOIN additional_code_descriptions
           ON additional_code_descriptions.additional_code_description_period_sid = additional_code_description_periods.additional_code_description_period_sid
    }
  end

  down do
    run %Q{
DROP VIEW all_additional_codes;
CREATE OR REPLACE VIEW all_additional_codes AS
SELECT
  meursing_additional_codes.meursing_additional_code_sid additional_code_sid,
  '7' additional_code_type_id,
  meursing_additional_codes.additional_code additional_code,
  null description,
  null language_id,
  meursing_additional_codes.validity_start_date validity_start_date,
  meursing_additional_codes.validity_end_date validity_end_date,
  meursing_additional_codes.operation_date operation_date,
  meursing_additional_codes.status status,
  meursing_additional_codes.workbasket_id workbasket_id,
  meursing_additional_codes.added_by_id added_by_id,
  meursing_additional_codes.added_at added_at,
  meursing_additional_codes."national" "national"
FROM meursing_additional_codes
UNION
SELECT
  additional_codes.additional_code_sid additional_code_sid,
  additional_codes.additional_code_type_id additional_code_type_id,
  additional_codes.additional_code additional_code,
  additional_code_descriptions.description description,
  additional_code_descriptions.language_id language_id,
  additional_codes.validity_start_date validity_start_date,
  additional_codes.validity_end_date validity_end_date,
  additional_codes.operation_date operation_date,
  additional_codes.status status,
  additional_codes.workbasket_id workbasket_id,
  additional_codes.added_by_id added_by_id,
  additional_codes.added_at added_at,
  additional_codes."national" "national"
FROM additional_codes,
additional_code_description_periods,
additional_code_descriptions
WHERE additional_code_description_periods.additional_code_sid = additional_codes.additional_code_sid
AND additional_code_description_periods.additional_code_type_id = additional_codes.additional_code_type_id
AND additional_code_description_periods.additional_code = additional_codes.additional_code
AND additional_code_descriptions.additional_code_description_period_sid = additional_code_description_periods.additional_code_description_period_sid
    }
  end
end
