module Measures
  class MeasuresController < ApplicationController
    include ::SearchCacheHelpers

    expose(:separator) do
      "_SM_"
    end

    expose(:search_ops) do
      ops = params[:search]

      if ops.present?
        ops.send("permitted=", true)
        ops = ops.to_h
      else
        ops = {}
      end

      setup_advanced_filters(ops)
    end

    expose(:current_search_code) do
      params[:search_code]
    end

    expose(:measures_search) do
      if search_mode?
        ::Measures::Search.new(cached_search_ops)
      else
        []
      end
    end

    expose(:search_results) do
      measures_search.results
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

    def download
      ::AvailableDownloadBroadcastWorker.perform_async(params[:uuid], current_search_code)
      render json: { result: :ok }
    end

    def quick_search
      #
      # This is a GET version of same search.
      # We need it in order to perform one parametr searches via links.
      #
      # For example: when you click on [measures] link in regulation
      # found in 'Find Regulation' section
      #
      perform_search
    end

    def search
      perform_search
    end

  private

    def setup_advanced_filters(ops)
      if params[:regulation_id].present?
        ops[:regulation] = {
          operator: 'is',
          value: params[:regulation_id]
        }
      end

      if params[:code].present?
        ops[:commodity_code] = {
          operator: 'is',
          value: params[:code]
        }
      end

      ops
    end

    def perform_search
      code = search_code
      ::MeasureService::TrackMeasureSids.new(code).run

      redirect_to measures_url(search_code: code)
    end
  end
end
