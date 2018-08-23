module Measures
  class BulksController < Measures::BulksBaseController

    include ::SearchCacheHelpers

    before_action :require_to_be_workbasket_owner!, only: [
      :update, :destroy
    ]

    before_action :require_no_to_be_awaiting_for_review!, only: [:edit, :update]

    expose(:current_page) do
      params[:page]
    end

    expose(:workbasket_container) do
      ::Measures::Workbasket::Items.new(
        workbasket, cached_search_ops
      ).prepare
    end

    expose(:cached_search_ops) do
      if workbasket.initial_items_populated.present?
        {
          measure_sids: workbasket_items.pluck(:record_id),
          page: current_page
        }
      else
        Rails.cache.read(params[:search_code]).merge(
          page: current_page
        )
      end
    end

    expose(:pagination_metadata) do
      {
        page: search_results.current_page,
        total_count: search_results.total_count,
        per_page: search_results.limit_value
      }
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
        workbasket,
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
        redirect_to edit_measures_bulk_url(
          workbasket.id,
          search_code: workbasket.search_code
        )
      end
    end

    def create
      self.workbasket = Workbaskets::Workbasket.new(
        status: :new_in_progress,
        type: :bulk_edit_of_measures,
        user: current_user,
        initial_search_results_code: params[:search_code],
        search_code: search_code
      )

      if workbasket.save
        redirect_to edit_measures_bulk_url(
          workbasket.id,
          search_code: workbasket.search_code
        )
      else
        redirect_to measures_url(notice: "You have to select at least of 1 measure from list!")
      end
    end

    expose(:submit_group_for_cross_check) do
      params[:mode] == "save_group_for_cross_check"
    end

    def update
      if bulk_saver.valid?
        if submit_group_for_cross_check
          bulk_saver.persist!
        end

        if submit_group_for_cross_check && params[:final_batch].to_s == "true"
          render json: {
            number_of_updated_measures: bulk_saver.collection_ops.count,
            redirect_url: edit_measures_bulk_url(workbasket.id, search_code: workbasket.search_code, submitted: true),
            success: :ok
          }, status: :ok

        else
          render json: bulk_saver.success_response,
                 status: :ok
        end
      else
        render json: bulk_saver.error_response,
               status: :unprocessable_entity
      end
    end

    def destroy
      workbasket.destroy

      render json: {}, head: :ok
    end

    private

      def require_no_to_be_awaiting_for_review!
        if workbasket.status == "awaiting_cross_check" && params[:submitted].blank?
          redirect_to edit_measures_bulk_url(workbasket.id, search_code: workbasket.search_code, submitted: true)

          return false
        end
      end
  end
end
