module Measures
  class BulksController < ApplicationController

    include ::SearchCacheHelpers

    skip_around_action :configure_time_machine

    expose(:current_page) do
      params[:page]
    end

    expose(:workbasket) do
      current_user.workbaskets
                  .detect do |el|
        el.id.to_s == params[:id]
      end
    end

    expose(:workbasket_container) do
      ::Measures::Workbasket::Items.new(
        workbasket, cached_search_ops
      ).prepare
    end

    expose(:search_results) do
      workbasket_container.pagination_metadata
    end

    expose(:json_collection) do
      workbasket_container.collection
    end

    expose(:search_ops) do
      {
        measure_sids: ::MeasureService::FetchMeasureSids.new(params).ids
      }
    end

    expose(:bulk_measures_collection) do
      JSON.parse(request.body.read)["bulk_measures_collection"]
    end

    expose(:bulk_saver) do
      ::Measures::BulkSaver.new(
        current_user,
        bulk_measures_collection
      )
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

      render plain: '', head: :ok
    end

    def remove_items
      # TODO

      render json: {}, head: :ok
    end

    def destroy
      # TODO

      redirect_to root_url
    end

    private

      def success_response
        render json: bulk_saver.collection_overview_summary,
               status: :ok
      end

      def errors_response
        render json: bulk_saver.errors_overview,
               status: :unprocessable_entity
      end
  end
end
