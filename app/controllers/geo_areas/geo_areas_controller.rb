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

    def validate_search_settings
      if search_form.valid?
        render json: {}, status: :ok
      else
        render json: {
          errors: search_form.parsed_errors
        }, status: :unprocessable_entity
      end
    end
  end
end
