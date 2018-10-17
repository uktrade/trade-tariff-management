module WorkbasketForms
  class CreateFootnoteForm

    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :footnote_type_id,
                  :description,
                  :operation_date,
                  :validity_start_date,
                  :validity_end_date

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
  end
end
