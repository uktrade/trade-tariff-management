class GoodsNomenclaturesController < ApplicationController
  respond_to :json
  around_action :configure_time_machine

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
