module Footnotes
  class FootnotesController < ::BaseController

    expose(:search_ops) do
      ops = params[:search]

      if ops.present?
        ops.send("permitted=", true)
        ops = ops.to_h
      else
        ops = {}
      end

      ops = ops.merge(
        page: params[:page]
      )

      ops
    end

    expose(:search_form) do
      FootnoteSearchForm.new(search_ops)
    end

    expose(:searcher) do
      FootnoteSearch.new(search_ops)
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

    def collection
      Footnote.q_search(params)
    end
  end
end
