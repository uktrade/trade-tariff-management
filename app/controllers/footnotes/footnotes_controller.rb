module Footnotes
  class FootnotesController < ::BaseController
    skip_around_action :configure_time_machine, only: %i[search validate_search_settings]

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

      ops[:sort_by] = params[:sort_by]
      ops[:sort_dir] = params[:sort_dir]

      ops
    end

    expose(:search_form) do
      FootnoteSearchForm.new(search_ops)
    end

    expose(:searcher) do
      FootnoteSearch.new(search_ops)
    end

    expose(:search_results) do
      measure_sids_are_invalid? ? nil : searcher.results
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

    def search
      #
      # We will back it later
      #
      # params[:sort_by] ||= "description"
      # params[:sort_dir] ||= "asc"
    end

    def collection
      Footnote.q_search(params)
    end

    def measure_sids_are_invalid?
      valid_sids = search_ops['measure_sids'].split(', ').map do |sid|
        sid.scan(/\D/).empty?
      end

      valid_sids.include? false
    end
  end
end
