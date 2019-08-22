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

  def search
    redirect_to goods_nomenclature_path(search_commodity_code)
  end

  def show
    set_nomenclature_view_date
    @search_value = params[:id].delete('^0-9')
    @nomenclature = GoodsNomenclature.actual.where(goods_nomenclature_item_id: @search_value).first.try(:sti_instance)
    @nomenclature_tree = NomenclatureTreeService.nomenclature_tree(params[:id], @view_date)

    if @nomenclature
      heading_code = "#{@search_value[0..3]}000000"
      @heading = GoodsNomenclature.actual.where(goods_nomenclature_item_id: heading_code).first.try(:sti_instance)
      @nomenclature_tree = NomenclatureTreeService.nomenclature_tree(heading_code, @view_date)
    else
      @errors = "Could not find a matching commodity '#{@search_value}'."
    end
  end

  private

  def search_commodity_code
    params[:search_commodity].present? ? params[:search_commodity] : 0
  end

end
