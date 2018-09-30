module WorkbasketForms
  class CreateGeographicalAreaForm < ::WorkbasketForms::BaseForm

    attr_accessor :geographical_code,
                  :geographical_area_id,
                  :description,
                  :parent_geographical_area_group_id,
                  :operation_date

  end
end
