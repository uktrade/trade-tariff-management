module WorkbasketForms
  class ManageNomenclatureForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :workbasket_name,
                  :reason_for_changes,
                  :description,
                  :description_validity_start_date,
                  :action,
                  :age


    def initialize(original_nomenclature)
      @original_nomenclature = original_nomenclature.goods_nomenclature_sid
    end

  end
end
