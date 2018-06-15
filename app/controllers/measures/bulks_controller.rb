module Measures
  class BulksController < ApplicationController

    include ::SearchCacheHelpers

    skip_around_action :configure_time_machine

    expose(:bulk_saver) do
      collection_ops = params[:measures]
      collection_ops.send("permitted=", true)
      collection_ops = collection_ops.to_h

      ::Measures::BulkSaver.new(current_user, collection_ops)
    end

    expose(:search_results) do
      ::Measure.bulk_edit_scope(cached_search_ops)
    end

    expose(:json_collection) do
      search_results.map(&:to_json)
    end

    expose(:search_ops) do
      {
        measure_sids: params[:measure_sids] || []
      }
    end

    def move_to_edit
      redirect_to edit_measures_bulks_url(search_code: search_code)
    end

    def edit
      if search_mode?
        respond_to do |format|
          format.json { render json: json_response }
          format.html
        end
      else
        redirect_to measures_url
      end
    end

    def validate
      if bulk_saver.valid?
        success_response
      else
        errors_response
      end
    end

    def create
      if bulk_saver.valid?
        bulk_saver.persist!

        success_response
      else
        errors_response
      end
    end

    private

      def success_response
        render json: bulk_saver.collection_overview_summary,
               status: :ok
      end

      def errors_response
        render json: bulk_saver.collection_with_errors,
               status: :unprocessable_entity
      end
  end
end
