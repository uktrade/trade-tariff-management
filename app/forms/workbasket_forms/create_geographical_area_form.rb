module WorkbasketForms
  class CreateGeographicalAreaForm < ::WorkbasketForms::BaseForm

    attr_accessor :role,
                  :base_regulation_role,
                  :antidumping_regulation_role,
                  :prefix,
                  :publication_year,
                  :regulation_number,
                  :number_suffix,
                  :replacement_indicator,
                  :information_text,
                  :effective_end_date,
                  :published_date,
                  :abrogation_date,
                  :pdf_data

  end
end
