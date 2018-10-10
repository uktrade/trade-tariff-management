module GeoAreas
  class GeoAreasController < ApplicationController

    expose(:search_ops) do
      (params[:search] || {}).merge(
        page: params[:page]
      )
    end

    expose(:search_form) do
      GeographicalAreaSearchForm.new(search_ops)
    end

    expose(:searcher) do
      GeographicalAreaSearch.new(search_ops)
    end

    expose(:search_results) do
      searcher.results
    end
  end
end
