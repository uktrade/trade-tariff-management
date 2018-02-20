class HomeController < ApplicationController

  expose(:search_code) do
    if params[:search].present? && params[:search][:code].present?
      params[:search][:code]
    else
      "9010"
    end
  end

  expose(:commodities) do
    Commodity.filter(Sequel.like(:goods_nomenclature_item_id, "#{search_code}%"))
  end
end
