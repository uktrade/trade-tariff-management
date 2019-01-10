module WorkbasketForms
  class CreateGeographicalAreaForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :geographical_code,
                  :geographical_area_id,
                  :description,
                  :parent_geographical_area_group_id,
                  :operation_date,
                  :validity_start_date,
                  :validity_end_date
  end
end
