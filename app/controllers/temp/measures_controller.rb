module Measures
  class MeasuresController < ApplicationController

    expose(:search_ops) {
      (params[:search] || {}).merge(
        page: params[:page]
      )
    }

    expose(:measures_search_form) do
      ::MeasuresSearchForm.new(search_ops)
    end

    expose(:measures_search) do
      ::MeasuresSearch.new(search_ops)
    end

    expose(:search_results) do
      measures_search.results
    end
  end
end
