module Quotas
  class BulksController < BulksBaseController
    before_action :require_to_be_workbasket_owner!, only: %i[
        update destroy
    ]

    expose(:current_page) do
      params[:page]
    end

    expose(:configure_step_settings) do
      {
        start_date: params[:validity_start_date],
        workbasket_action: params[:workbasket_action],
        regulation: params[:regulation_id].blank? ? nil : ::BaseOrModificationRegulationSearch.new(params[:regulation_id]).result.first.try(:to_json),
        regulation_id: params[:regulation_id],
        regulation_role: params[:regulation_role],
        reason: params[:reason],
        title: params[:workbasket_name],
        suspension_date: params[:suspension_date]
      }
    end

    expose(:main_step_settings) do
      {
        'operation_date': params[:validity_start_date],
        'regulation_id': params[:regulation_id],
        'regulation_role': params[:regulation_role]
      }
    end

    expose(:workbasket_settings) do
      workbasket.settings
    end

    expose(:initial_step_url) do
      if workbasket_settings.edit_quota_workbasket?
        edit_quotas_bulk_url(
          workbasket.id,
            step: :main
        )
      else
        edit_quotas_bulk_url(
          workbasket.id,
            search_code: workbasket_settings.initial_search_results_code
        )
      end
    end

    expose(:current_step) { params[:step] }

    expose(:previous_step_url) do
      edit_quotas_bulk_url(
        workbasket.id,
          step: previous_step
      )
    end

    expose(:read_only_section_url) do
      edit_quotas_bulk_url(workbasket.id)
    end

    expose(:quota_periods) do
      workbasket_settings.quota_periods
    end

    expose(:parent_quota_periods) do
      workbasket_settings.parent_quota_periods
    end

    expose(:saver_mode) { params[:mode] }

    expose(:previous_step) do
      step_pointer.previous_step
    end

    expose(:submitted_url) do
      submitted_for_cross_check_quotas_bulk_url(workbasket.id)
    end

    expose(:submit_group_for_cross_check) do
      params[:mode] == "save_group_for_cross_check"
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
        {
            measure_sids: ::Measures::Search.new(measures_search_ops).measure_sids,
            page: current_page
        }
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

    expose(:measures_search_ops) do
      {
          'order_number': {
              'enabled': '1',
              'operator': 'is',
              'value': workbasket_settings.quota_definition.quota_order_number_id
          },
          'valid_to': {
              'enabled': '1',
              'operator': 'is_after_or_nil',
              'value': workbasket.operation_date
          }
      }
    end

    expose(:settings_params) do
      ops = params[:settings]
      ops.send("permitted=", true) if ops.present?
      ops = (ops || {}).to_h

      ops
    end

    expose(:step_pointer) do
      ::WorkbasketValueObjects::CreateQuota::StepPointer.new(current_step)
    end

    expose(:form) do
      WorkbasketForms::CreateQuotaForm.new(Measure.new)
    end

    expose(:attributes_parser) do
      ::WorkbasketValueObjects::CreateQuota::AttributesParser.new(
        workbasket_settings,
          current_step
      )
    end

    expose(:submit_for_cross_check) do
      ::WorkbasketInteractions::CreateQuota::SubmitForCrossCheck.new(
        current_user, workbasket
      )
    end

    expose(:edit_quota_measures_ops) do
      JSON.parse(request.body.read)["bulk_measures_collection"]
    end

    expose(:remove_suspension_ops) do
      {}
    end

    expose(:stop_quota_ops) do
      {}
    end

    expose(:suspend_quota_ops) do
      {}
    end

    WORKBASKET_ACTION_SAVER = {
        'edit_quota_measures' => '::Measures::BulkSaver',
        'remove_suspension' => '::Quotas::RemoveSuspensionSaver',
        'stop_quota' => '::Quotas::StopSaver',
        'suspend_quota' => '::Quotas::SuspendSaver'
    }.freeze

    expose(:bulk_saver) do
      WORKBASKET_ACTION_SAVER[workbasket_settings.workbasket_action].constantize.new(
        current_user,
          workbasket,
          send("#{workbasket_settings.workbasket_action}_ops")
      )
    end

    expose(:saver) do
      ::WorkbasketInteractions::EditQuota::SettingsSaver.new(
        workbasket,
          current_step,
          saver_mode,
          settings_params
      )
    end

    expose(:json_response) do
      {
          collection: json_collection,
          total_pages: search_results.total_pages,
          current_page: search_results.current_page,
          has_more: !search_results.last_page?
      }
    end

    def edit
      respond_to do |format|
        format.json { render json: json_response }
        format.html
      end
    end

    def create
      if params[:clone].present?
        handle_clone_quota_request
      else
        handle_edit_quota_request
      end
    end

    def handle_edit_quota_request
      self.workbasket = Workbaskets::Workbasket.new(
        status: :new_in_progress,
        type: :bulk_edit_of_quotas,
        user: current_user
      )

      if workbasket.save
        quota_sid = params[:quota_sids].first
        quota_settings = ::WorkbasketInteractions::EditQuota::SettingsExtractor.new(quota_sid)
        workbasket_settings.update(
          initial_search_results_code: params[:search_code],
          initial_quota_sid: quota_sid,
          main_step_settings_jsonb: quota_settings.main_step_settings.to_json,
          configure_quota_step_settings_jsonb: quota_settings.configure_quota_step_settings.to_json,
          conditions_footnotes_step_settings_jsonb: quota_settings.conditions_footnotes_step_settings.to_json
        )

        redirect_to work_with_selected_quotas_bulk_url(
          workbasket.id
                    )
      else
        redirect_to quotas_url(
          notice: "You have to select 1 quota from list!"
                    )
      end
    end

    def handle_clone_quota_request
      self.workbasket = Workbaskets::Workbasket.new(
        status: :new_in_progress,
        type: :clone_quota,
        user: current_user
      )
      if workbasket.save

        quota_sid = params[:quota_sids].first
        workbasket_settings.update(
          initial_search_results_code: params[:search_code],
          initial_quota_sid: quota_sid
        )

        redirect_to configure_cloned_quotas_bulk_url(
          workbasket.id
                    )
      end
    end

    def persist_work_with_selected
      workbasket_settings.set_settings_for!("configure", configure_step_settings)
      workbasket_settings.set_settings_for!("main", workbasket_settings.main_step_settings.merge(main_step_settings))
      workbasket_settings.set_workbasket_system_data!

      if workbasket_settings.editable_workbasket?
        redirect_to initial_step_url
      else
        if bulk_saver.valid?
          bulk_saver.persist!
          workbasket.move_status_to!(current_user, :awaiting_cross_check)

          redirect_to quotas_url(
            search_code: workbasket_settings.initial_search_results_code,
            previous_workbasket_id: workbasket.id
                      )
        end
      end
    end

    def persist_configure_cloned
      workbasket.update(title: params['workbasket_name'])
      quota_settings = ::WorkbasketInteractions::EditQuota::SettingsExtractor.new(workbasket_settings.initial_quota_sid, params[:exclusions])
      workbasket_settings.update(
        main_step_settings_jsonb: quota_settings.main_step_settings.to_json,
        configure_quota_step_settings_jsonb: quota_settings.configure_quota_step_settings.to_json,
        conditions_footnotes_step_settings_jsonb: quota_settings.conditions_footnotes_step_settings.to_json
      )
      redirect_to edit_create_quotum_url(
        workbasket.id,
          step: :main
      )
    end

    def update
      if workbasket_settings.edit_quota_workbasket?
        handle_update_edit_quota_request
      else
        handle_update_edit_quota_measures_request
      end
    end

    def handle_update_edit_quota_measures_request
      if bulk_saver.valid?
        if submit_group_for_cross_check && final_saving_batch
          bulk_saver.persist!

          render json: bulk_saver.success_response.merge(
            redirect_url: submitted_for_cross_check_quotas_bulk_url(workbasket.id)
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

    def handle_update_edit_quota_request
      if step_pointer.review_and_submit_step?
        submit_for_cross_check.run!

        render json: { redirect_url: submitted_url },
               status: :ok
      else
        saver.save!

        if step_pointer.main_step?
          render json: saver.success_ops,
                 status: :ok
          return
        end

        if saver.valid?
          workbasket_settings.track_step_validations_status!(current_step, true)
          saver.persist! if workbasket_data_can_be_persisted?

          render json: saver.success_ops,
                 status: :ok
        else
          workbasket_settings.track_step_validations_status!(current_step, false)

          render json: {
              step: current_step,
              errors: saver.errors,
              candidates_with_errors: saver.candidates_with_errors
          }, status: :unprocessable_entity
        end
      end
    end

    def destroy
      workbasket.clean_up_workbasket!

      redirect_to root_url
    end

  private

    def check_if_action_is_permitted!
      if (step_pointer.conditions_footnotes? ||
          step_pointer.review_and_submit_step?) &&
          !workbasket_settings.validations_passed?(previous_step)

        redirect_to previous_step_url
        false
      end
    end

    def workbasket_data_can_be_persisted?
      step_pointer.conditions_footnotes? &&
        saver_mode == 'continue'
    end
  end
end
