module WorkbasketForms
  class EditNomenclatureForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :original_nomenclature,
                  :description,
                  :validity_start_date_day,
                  :validity_start_date_month,
                  :validity_start_date_year,
                  :validity_start_date

    def initialize(original_nomenclature, settings = {})
      @original_nomenclature = original_nomenclature
      @description = settings.present? ? settings[:description] : ""
      @validity_start_date = settings.present? ? settings[:validity_start_date] : nil
      @validity_start_date_day = @validity_start_date.present? ? @validity_start_date.strftime("%d") : Date.tomorrow.strftime("%d")
      @validity_start_date_month = @validity_start_date.present? ? @validity_start_date.strftime("%m") : Date.tomorrow.strftime("%m")
      @validity_start_date_year = @validity_start_date.present? ? @validity_start_date.strftime("%Y") : Date.tomorrow.strftime("%Y")
    end

    def original_nomenclature_description
      @original_nomenclature.description
    end

  end
end
