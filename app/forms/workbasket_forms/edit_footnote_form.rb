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
  end
end
