module WorkbasketForms
  class EditFootnoteForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :original_footnote,
                  :reason_for_changes,
                  :operation_date,
                  :description,
                  :description_validity_start_date,
                  :validity_start_date,
                  :validity_end_date,
                  :commodity_codes,
                  :measure_sids

    def initialize(original_footnote)
      @original_footnote = original_footnote
    end

    def original_footnote_description
      original_footnote.description
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
