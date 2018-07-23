Sequel.migration do
  change do
    tables_to_change = [
      :measures_oplog,
      :footnotes_oplog,
      :footnote_descriptions_oplog,
      :footnote_description_periods_oplog,
      :footnote_association_measures_oplog,
      :measure_components_oplog,
      :measure_conditions_oplog,
      :measure_condition_components_oplog
    ]

    tables_to_change.map do |view_name|
      run "DROP VIEW public.#{view_name.to_s.gsub('_oplog', '')};"
    end

    tables_to_change.map do |table_name|
      alter_table table_name do
        unless table_name == :measures_oplog
          add_column :status, String
          add_column :workbasket_id, Integer
        end

        add_column :workbasket_sequence_number, Integer
      end
    end

    run %Q{
      CREATE VIEW public.measures AS
       SELECT measures1.measure_sid,
          measures1.measure_type_id,
          measures1.geographical_area_id,
          measures1.goods_nomenclature_item_id,
          measures1.validity_start_date,
          measures1.validity_end_date,
          measures1.measure_generating_regulation_role,
          measures1.measure_generating_regulation_id,
          measures1.justification_regulation_role,
          measures1.justification_regulation_id,
          measures1.stopped_flag,
          measures1.geographical_area_sid,
          measures1.goods_nomenclature_sid,
          measures1.ordernumber,
          measures1.additional_code_type_id,
          measures1.additional_code_id,
          measures1.additional_code_sid,
          measures1.reduction_indicator,
          measures1.export_refund_nomenclature_sid,
          measures1."national",
          measures1.tariff_measure_number,
          measures1.invalidated_by,
          measures1.invalidated_at,
          measures1.oid,
          measures1.operation,
          measures1.operation_date,
          measures1.added_by_id,
          measures1.added_at,
          measures1.status,
          measures1.last_status_change_at,
          measures1.last_update_by_id,
          measures1.updated_at,
          measures1.workbasket_id,
          measures1.searchable_data,
          measures1.searchable_data_updated_at,
          measures1.workbasket_sequence_number
         FROM public.measures_oplog measures1
        WHERE ((measures1.oid IN ( SELECT max(measures2.oid) AS max
                 FROM public.measures_oplog measures2
                WHERE (measures1.measure_sid = measures2.measure_sid))) AND ((measures1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE VIEW public.footnotes AS
       SELECT footnotes1.footnote_id,
          footnotes1.footnote_type_id,
          footnotes1.validity_start_date,
          footnotes1.validity_end_date,
          footnotes1."national",
          footnotes1.oid,
          footnotes1.operation,
          footnotes1.operation_date,
          footnotes1.added_by_id,
          footnotes1.added_at,
          footnotes1.status,
          footnotes1.workbasket_id,
          footnotes1.workbasket_sequence_number
         FROM public.footnotes_oplog footnotes1
        WHERE ((footnotes1.oid IN ( SELECT max(footnotes2.oid) AS max
                 FROM public.footnotes_oplog footnotes2
                WHERE (((footnotes1.footnote_type_id)::text = (footnotes2.footnote_type_id)::text) AND ((footnotes1.footnote_id)::text = (footnotes2.footnote_id)::text)))) AND ((footnotes1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE VIEW public.footnote_descriptions AS
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
          footnote_descriptions1.added_by_id,
          footnote_descriptions1.status,
          footnote_descriptions1.workbasket_id,
          footnote_descriptions1.workbasket_sequence_number
         FROM public.footnote_descriptions_oplog footnote_descriptions1
        WHERE ((footnote_descriptions1.oid IN ( SELECT max(footnote_descriptions2.oid) AS max
                 FROM public.footnote_descriptions_oplog footnote_descriptions2
                WHERE ((footnote_descriptions1.footnote_description_period_sid = footnote_descriptions2.footnote_description_period_sid) AND ((footnote_descriptions1.footnote_id)::text = (footnote_descriptions2.footnote_id)::text) AND ((footnote_descriptions1.footnote_type_id)::text = (footnote_descriptions2.footnote_type_id)::text)))) AND ((footnote_descriptions1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE VIEW public.footnote_description_periods AS
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
          footnote_description_periods1.added_by_id,
          footnote_description_periods1.status,
          footnote_description_periods1.workbasket_id,
          footnote_description_periods1.workbasket_sequence_number
         FROM public.footnote_description_periods_oplog footnote_description_periods1
        WHERE ((footnote_description_periods1.oid IN ( SELECT max(footnote_description_periods2.oid) AS max
                 FROM public.footnote_description_periods_oplog footnote_description_periods2
                WHERE (((footnote_description_periods1.footnote_id)::text = (footnote_description_periods2.footnote_id)::text) AND ((footnote_description_periods1.footnote_type_id)::text = (footnote_description_periods2.footnote_type_id)::text) AND (footnote_description_periods1.footnote_description_period_sid = footnote_description_periods2.footnote_description_period_sid)))) AND ((footnote_description_periods1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE VIEW public.footnote_association_measures AS
       SELECT footnote_association_measures1.measure_sid,
          footnote_association_measures1.footnote_type_id,
          footnote_association_measures1.footnote_id,
          footnote_association_measures1."national",
          footnote_association_measures1.oid,
          footnote_association_measures1.operation,
          footnote_association_measures1.operation_date,
          footnote_association_measures1.added_at,
          footnote_association_measures1.added_by_id,
          footnote_association_measures1.status,
          footnote_association_measures1.workbasket_id,
          footnote_association_measures1.workbasket_sequence_number
         FROM public.footnote_association_measures_oplog footnote_association_measures1
        WHERE ((footnote_association_measures1.oid IN ( SELECT max(footnote_association_measures2.oid) AS max
                 FROM public.footnote_association_measures_oplog footnote_association_measures2
                WHERE ((footnote_association_measures1.measure_sid = footnote_association_measures2.measure_sid) AND ((footnote_association_measures1.footnote_id)::text = (footnote_association_measures2.footnote_id)::text) AND ((footnote_association_measures1.footnote_type_id)::text = (footnote_association_measures2.footnote_type_id)::text)))) AND ((footnote_association_measures1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE VIEW public.measure_components AS
       SELECT measure_components1.measure_sid,
          measure_components1.duty_expression_id,
          measure_components1.duty_amount,
          measure_components1.monetary_unit_code,
          measure_components1.measurement_unit_code,
          measure_components1.measurement_unit_qualifier_code,
          measure_components1.oid,
          measure_components1.operation,
          measure_components1.operation_date,
          measure_components1.added_by_id,
          measure_components1.added_at,
          measure_components1."national",
          measure_components1.status,
          measure_components1.workbasket_id,
          measure_components1.workbasket_sequence_number
         FROM public.measure_components_oplog measure_components1
        WHERE ((measure_components1.oid IN ( SELECT max(measure_components2.oid) AS max
                 FROM public.measure_components_oplog measure_components2
                WHERE ((measure_components1.measure_sid = measure_components2.measure_sid) AND ((measure_components1.duty_expression_id)::text = (measure_components2.duty_expression_id)::text)))) AND ((measure_components1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE VIEW public.measure_conditions AS
       SELECT measure_conditions1.measure_condition_sid,
          measure_conditions1.measure_sid,
          measure_conditions1.condition_code,
          measure_conditions1.component_sequence_number,
          measure_conditions1.condition_duty_amount,
          measure_conditions1.condition_monetary_unit_code,
          measure_conditions1.condition_measurement_unit_code,
          measure_conditions1.condition_measurement_unit_qualifier_code,
          measure_conditions1.action_code,
          measure_conditions1.certificate_type_code,
          measure_conditions1.certificate_code,
          measure_conditions1.oid,
          measure_conditions1.operation,
          measure_conditions1.operation_date,
          measure_conditions1.added_by_id,
          measure_conditions1.added_at,
          measure_conditions1."national",
          measure_conditions1.status,
          measure_conditions1.workbasket_id,
          measure_conditions1.workbasket_sequence_number
         FROM public.measure_conditions_oplog measure_conditions1
        WHERE ((measure_conditions1.oid IN ( SELECT max(measure_conditions2.oid) AS max
                 FROM public.measure_conditions_oplog measure_conditions2
                WHERE (measure_conditions1.measure_condition_sid = measure_conditions2.measure_condition_sid))) AND ((measure_conditions1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE VIEW public.measure_condition_components AS
       SELECT measure_condition_components1.measure_condition_sid,
          measure_condition_components1.duty_expression_id,
          measure_condition_components1.duty_amount,
          measure_condition_components1.monetary_unit_code,
          measure_condition_components1.measurement_unit_code,
          measure_condition_components1.measurement_unit_qualifier_code,
          measure_condition_components1.oid,
          measure_condition_components1.operation,
          measure_condition_components1.operation_date,
          measure_condition_components1.added_by_id,
          measure_condition_components1.added_at,
          measure_condition_components1."national",
          measure_condition_components1.status,
          measure_condition_components1.workbasket_id,
          measure_condition_components1.workbasket_sequence_number
         FROM public.measure_condition_components_oplog measure_condition_components1
        WHERE ((measure_condition_components1.oid IN ( SELECT max(measure_condition_components2.oid) AS max
                 FROM public.measure_condition_components_oplog measure_condition_components2
                WHERE ((measure_condition_components1.measure_condition_sid = measure_condition_components2.measure_condition_sid) AND ((measure_condition_components1.duty_expression_id)::text = (measure_condition_components2.duty_expression_id)::text)))) AND ((measure_condition_components1.operation)::text <> 'D'::text));
    }
  end
end
