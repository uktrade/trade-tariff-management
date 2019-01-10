module WorkbasketForms
  class CreateFootnoteForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :footnote_type_id,
                  :description,
                  :operation_date,
                  :validity_start_date,
                  :validity_end_date,
                  :commodity_codes,
                  :measure_sids

    def footnote_types_list
      FootnoteType.actual.map do |ft|
        {
          footnote_type_id: ft.footnote_type_id,
          description: ft.description
        }
      end.sort_by { |a| a[:footnote_type_id] }
    end

    def goods_footnote_type_ids
      FootnoteType::NOMENCLATURE_TYPES
    end

    def measures_footnote_type_ids
      FootnoteType::MEASURE_TYPES
    end

    def goods_and_measures_footnote_type_ids
      goods_footnote_type_ids + measures_footnote_type_ids
    end
  end
end
