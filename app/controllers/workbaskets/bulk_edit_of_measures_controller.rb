module Workbaskets
  class BulkEditOfMeasuresController < Workbaskets::BaseController
    include ::SearchCacheHelpers

    expose(:sub_klass) { "BulkEditOfMeasures" }
    expose(:settings_type) { :bulk_edit_of_measures }

    expose(:initial_step_url) do
      edit_bulk_edit_of_measure_url(
        workbasket.id,
        step: :main
      )
    end

    expose(:previous_step_url) do
      edit_bulk_edit_of_measure_url(
        workbasket.id,
        step: previous_step
      )
    end

    expose(:read_only_section_url) do
      bulk_edit_of_measure_url(workbasket.id)
    end

    expose(:submitted_url) do
      submitted_for_cross_check_bulk_edit_of_measure_url(workbasket.id)
    end

    expose(:separator) do
      "_BEM_"
    end

    expose(:final_saving_batch) do
      params[:final_batch].to_s == "true"
    end

    expose(:workbasket_container) do
      ::Measures::Workbasket::Items.new(
        workbasket, cached_search_ops
      ).prepare
    end

    expose(:cached_search_ops) do
      if workbasket_settings.initial_items_populated.present?
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

    expose(:bulk_measures_collection) do
      JSON.parse(request.body.read)["bulk_measures_collection"]
    end

    expose(:json_response) do
      {
        collection: json_collection,
        total_pages: search_results.total_pages,
        current_page: search_results.current_page,
        has_more: !search_results.last_page?
      }
    end

    def show
      respond_to do |format|
        format.json { render json: json_response }
        format.html
      end
    end

  private

    def check_if_action_is_permitted!
      if step_pointer.review_and_submit_step? &&
          !workbasket_settings.validations_passed?(previous_step)

        redirect_to previous_step_url
        false
      end
    end

    def workbasket_data_can_be_persisted?
      step_pointer.duties_conditions_footnotes? &&
        saver_mode == 'continue'
    end
  end
end
