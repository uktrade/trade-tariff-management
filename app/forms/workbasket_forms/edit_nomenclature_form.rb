module WorkbasketForms
  class EditNomenclatureForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :original_nomenclature,
                  :description

    def initialize(original_nomenclature)
      original_nomenclature = original_nomenclature
    end

    def original_nomenclature_description
      original_nomenclature.description
    end

  end
end
