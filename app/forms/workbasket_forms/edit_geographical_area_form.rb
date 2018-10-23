module WorkbasketForms
  class EditGeographicalAreaForm

    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :geographical_code,
                  :geographical_area_id,
                  :original_geographical_area,
                  :reason_for_changes,
                  :operation_date,
                  :description,
                  :description_validity_start_date,
                  :parent_geographical_area_group_id,
                  :validity_start_date,
                  :validity_end_date

    def initialize(original_geographical_area)
      @original_geographical_area = original_geographical_area
    end

    def original_geographical_area_description
      original_geographical_area.description
    end
  end
end
