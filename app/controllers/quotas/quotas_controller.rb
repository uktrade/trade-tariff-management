module Quotas
  class QuotasController < ApplicationController

    include ::SearchCacheHelpers
    skip_around_action :configure_time_machine, only: [:index, :search]

    expose(:separator) do
      "_SQ_"
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

    expose(:quotas_search) do
      if search_mode?
        ::Quotas::Search.new(cached_search_ops)
      else
        []
      end
    end

    expose(:search_results) do
      quotas_search.results
    end

    expose(:json_collection) do
      search_results.map(&:to_table_json)
    end

    expose(:previous_workbasket) do
      ::Workbaskets::Workbasket.find(id: params[:previous_workbasket_id]) if params[:previous_workbasket_id].present?
    end

    def index
      respond_to do |format|
        format.json { render json: json_response }
        format.html
      end
    end

    def search
      code = search_code
      redirect_to quotas_url(search_code: code)
    end
  end
end
