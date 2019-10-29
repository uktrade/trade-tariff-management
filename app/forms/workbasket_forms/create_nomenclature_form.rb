module WorkbasketForms
  class CreateNomenclatureForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :original_nomenclature,
                  :goods_nomenclature_item_id,
                  :description,
                  :producline_suffix,
                  :number_indents,
                  :origin_code,
                  :origin_producline_suffix,
                  :validity_start_date_day,
                  :validity_start_date_month,
                  :validity_start_date_year,
                  :validity_start_date

    def initialize(original_nomenclature, settings = {})
      @original_nomenclature = original_nomenclature
      @description = settings.present? ? settings[:description] : ""
      @goods_nomenclature_item_id = settings[:goods_nomenclature_item_id]
      @validity_start_date = settings.present? ? settings[:validity_start_date] : nil
      @validity_start_date_day = @validity_start_date.present? ? @validity_start_date.strftime("%d") : nil
      @validity_start_date_month = @validity_start_date.present? ? @validity_start_date.strftime("%m") : nil
      @validity_start_date_year = @validity_start_date.present? ? @validity_start_date.strftime("%Y") : nil
      @producline_suffix = settings[:producline_suffix]
      @number_indents = settings[:number_indents] || original_nomenclature.number_indents + 1
      @origin_code = settings[:origin_nomenclature] || original_nomenclature.goods_nomenclature_item_id
      @origin_producline_suffix = settings[:origin_producline_suffix] || original_nomenclature.producline_suffix
    end

    def original_nomenclature_description
      @original_nomenclature.description
    end

  end
end
