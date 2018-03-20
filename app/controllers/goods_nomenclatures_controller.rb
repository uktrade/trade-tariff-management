class GoodsNomenclaturesController < ApplicationController
  respond_to :json

  def index
    @nomenclature = GoodsNomenclature.where(goods_nomenclature_item_id: params[:q]).first

    if @nomenclature.present?
      render partial: "shared/tariff_breadcrumbs"
    else
      head :not_found
    end
  end
end
