module WorkbasketForms
  class EditNomenclatureForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :original_nomenclature,
                  :description,
                  :validity_start_date

    def initialize(original_nomenclature, settings = {})
      @original_nomenclature = original_nomenclature
      @description = settings.present? ? settings[:description] : ""
      @validity_start_date = settings.present? ? settings[:validity_start_date] : nil
    end

    def original_nomenclature_description
      @original_nomenclature.description
    end

  end
end
