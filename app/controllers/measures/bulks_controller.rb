module Measures
  class BulksController < ApplicationController

    include ::SearchCacheHelpers

    skip_around_action :configure_time_machine

    expose(:workbasket) do
      current_user.workbaskets
                  .find(params[:id])
    end

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
        measure_sids: target_measure_sids
      }
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
      self.workbasket = Workbaskets::Workbasket.new(status: :new, user: current_user)

      if workbasket.save
        redirect_to edit_measures_bulk_url(workbasket.id, search_code: search_code)
      else
        redirect_to measures_url(notice: "You have to select at least of 1 measure from list!")
      end
    end

    def update
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

      def target_measure_sids
        ::MeasureService::FetchMeasureSids.new(
          search_code, params
        ).ids
      end
  end
end
