module AdditionalCodes
  class AdditionalCodesController < ApplicationController

    include ::SearchCacheHelpers
    skip_around_action :configure_time_machine, only: [:index, :search]

    expose(:separator) do
      "_SAD_"
    end

    expose(:additional_code) do
      AdditionalCode.by_code(params[:code])
    end

    expose(:search_ops) do
      ops = params[:search]

      if ops.present?
        ops.send("permitted=", true)
        ops = ops.to_h
      else
        ops = {}
      end
      ops
    end

    expose(:additional_codes_search) do
      if search_mode?
        ::AdditionalCodes::Search.new(cached_search_ops)
      else
        []
      end
    end

    expose(:search_results) do
      additional_codes_search.results
    end

    expose(:json_collection) do
      search_results.map(&:to_table_json)
    end

    def index
      respond_to do |format|
        format.json { render json: json_response }
        format.html
      end
    end

    def search
      code = search_code
      ::AdditionalCodeService::TrackAdditionalCodeSids.new(code).run
      redirect_to additional_codes_url(search_code: code)
    end

    def collection
      AdditionalCode.q_search(params)
    end

    def preview
      if additional_code.present?
        render partial: "measures/bulks/additional_code_preview"
      else
        head :not_found
      end
    end
  end
end
