module WorkbasketForms
  class EditNomenclatureDatesForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :original_nomenclature,
                  :validity_start_date,
                  :validity_end_date

    def initialize(original_nomenclature, settings = {})
      @original_nomenclature = original_nomenclature
      #@description = settings.present? ? settings[:description] : ""
      @validity_start_date = settings.present? ? settings[:validity_start_date] : nil
      @validity_end_date = settings.present? ? settings[:validity_end_date] : nil
      #@validity_start_date_day = @validity_start_date.present? ? @validity_start_date.strftime("%d") : nil
      #@validity_start_date_month = @validity_start_date.present? ? @validity_start_date.strftime("%m") : nil
      #@validity_start_date_year = @validity_start_date.present? ? @validity_start_date.strftime("%Y") : nil
    end

    #def original_nomenclature_description
    #  @original_nomenclature.description
    #end

  end
end
