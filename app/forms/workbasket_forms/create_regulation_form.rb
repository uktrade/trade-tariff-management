module WorkbasketForms
  class CreateRegulationForm < ::WorkbasketForms::BaseForm

    attr_accessor :geographical_code,
                  :geographical_area_id,
                  :parent_geographical_area_group_sid,
                  :start_date,
                  :end_date,
                  :operation_date
  end
end
