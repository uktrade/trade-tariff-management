module WorkbasketForms
  class EditNomenclatureDatesForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :original_nomenclature,
                  :validity_start_date,
                  :validity_end_date

    def initialize(original_nomenclature, settings = {})
      @original_nomenclature = original_nomenclature
      @validity_start_date = settings.present? ? settings[:validity_start_date] : workbasket.settings.validity_start_date
      @validity_end_date = settings.present? ? settings[:validity_end_date] : workbasket.settings.validity_end_date
    end

  end
end
