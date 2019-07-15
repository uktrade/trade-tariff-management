module AdditionalCodes
  class BulksController < BulksBaseController
    include ::SearchCacheHelpers

    before_action :require_to_be_workbasket_owner!, only: %i[
        update destroy
    ]

    expose(:separator) do
      "_BEAC_"
    end

    expose(:current_page) do
      params[:page]
    end

    expose(:main_step_settings) do
      {
          reason: params[:reason],
          title: params[:title]
      }
    end

    expose(:workbasket_settings) do
      workbasket.settings
    end

    expose(:edit_url) do
      edit_additional_codes_bulk_url(
        workbasket.id,
          search_code: workbasket_settings.search_code
      )
    end

    expose(:submit_group_for_cross_check) do
      params[:mode] == "save_group_for_cross_check"
    end

    expose(:final_saving_batch) do
      params[:final_batch].to_s == "true"
    end

    expose(:workbasket_container) do
      ::AdditionalCodes::Workbasket::Items.new(
        workbasket, cached_search_ops
      ).prepare
    end

    expose(:cached_search_ops) do
      if workbasket_settings.initial_items_populated.present?
        {
            additional_code_sids: workbasket_items.pluck(:record_id),
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
          additional_code_sids: ::AdditionalCodeService::FetchAdditionalCodeSids.new(params).ids
      }
    end

    expose(:bulk_additional_codes_collection) do
      JSON.parse(request.body.read)["bulk_additional_codes_collection"]
    end

    expose(:bulk_saver) do
      ::AdditionalCodes::BulkSaver.new(
        current_user,
          workbasket,
          bulk_additional_codes_collection
      )
    end

    expose(:json_collection) do
      workbasket_container.collection
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

    def edit
      if search_mode?
        respond_to do |format|
          format.json { render json: json_response }
          format.html
        end

      else
        redirect_to edit_url
      end
    end

    def create
      self.workbasket = Workbaskets::Workbasket.new(
        status: :new_in_progress,
        type: :bulk_edit_of_additional_codes,
        user: current_user
      )

      if workbasket.save
        workbasket_settings.update(
          initial_search_results_code: params[:search_code],
          search_code: search_code
        )

        redirect_to work_with_selected_additional_codes_bulk_url(
          workbasket.id,
                        search_code: workbasket_settings.search_code
                    )
      else
        redirect_to additional_codes_url(
          notice: "You have to select at least of 1 additional code from list!"
                    )
      end
    end

    def persist_work_with_selected
      workbasket_settings.set_settings_for!("main", main_step_settings)
      workbasket_settings.set_workbasket_system_data!

      redirect_to edit_url
    end

    def update
      if bulk_saver.valid?
        if submit_group_for_cross_check && final_saving_batch
          bulk_saver.persist!

          render json: bulk_saver.success_response.merge(
            redirect_url: submitted_for_cross_check_additional_codes_bulk_url(workbasket.id)
          ), status: :ok
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
      workbasket.clean_up_workbasket!

      redirect_to root_url
    end

    def move_to_editing_mode
      workbasket.move_to_editing!(current_admin: current_user)

      redirect_to edit_additional_codes_bulk_url
    end

    def withdraw_workbasket_from_workflow
      move_to_editing_mode
    end
  end
end
