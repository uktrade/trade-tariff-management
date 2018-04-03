module Measures
  class GoodsNomenclaturesController < ApplicationController
    respond_to :json

    def index
      @nomenclature = GoodsNomenclature.actual
                                       .where(goods_nomenclature_item_id: params[:q])
                                       .first.try(:sti_instance)

      if @nomenclature.present?
        render partial: "shared/tariff_breadcrumbs"
      else
        head :not_found
      end
    end
  end
end
