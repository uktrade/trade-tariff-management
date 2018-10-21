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
      end.sort do |a, b|
        a[:footnote_type_id] <=> b[:footnote_type_id]
      end
    end

    def show_commodity_codes_block
      show_type_block?(:nomenclature_type)
    end

    def show_measures_block
      show_type_block?(:measure_type)
    end

    def show_type_block?(scope)
      FootnoteType.public_send(scope)
                  .pluck(:footnote_type_id)
                  .include?(original_footnote.footnote_type_id)
    end
  end
end
