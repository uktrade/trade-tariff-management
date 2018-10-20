module WorkbasketForms
  class EditFootnoteForm

    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :reason_for_changes,
                  :operation_date,
                  :description,
                  :description_validity_start_date,
                  :validity_start_date,
                  :validity_end_date,
                  :commodity_codes,
                  :measure_sids

    def nomenclature_footnote_type_ids
      FootnoteType.nomenclature_type
                  .map(&:footnote_type_id)
    end

    def measure_footnote_type_ids
      FootnoteType.measure_type
                  .map(&:footnote_type_id)
    end
  end
end
