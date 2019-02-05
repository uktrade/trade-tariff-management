module Workbaskets
  class BaseController < BulksBaseController
    around_action :configure_time_machine

    before_action :require_to_be_workbasket_owner!,
                  :require_step_declaration_in_params!,
                  :check_if_action_is_permitted!,
                  :status_check!, only: %i[edit update]

    before_action :clean_up_persisted_data_on_update!,
                  :handle_submit_for_cross_check!, only: [:update]

    before_action :require_workbasket_to_be_new_in_progress!, only: [:destroy]

    expose(:workbasket_settings) do
      workbasket.settings
    end

    expose(:current_step) { params[:step] }

    expose(:previous_step) do
      step_pointer.previous_step
    end

    expose(:saver_mode) { params[:mode] }

    expose(:settings_params) do
      ops = params[:settings]
      ops.send("permitted=", true) if ops.present?
      ops = (ops || {}).to_h

      ops
    end

    expose(:form) do
      "WorkbasketForms::#{sub_klass}Form".constantize.new(
        Measure.new
      )
    end

    expose(:step_pointer) do
      "::WorkbasketValueObjects::#{sub_klass}::StepPointer".constantize
                                                           .new(current_step)
    end

    expose(:attributes_parser) do
      "::WorkbasketValueObjects::#{sub_klass}::AttributesParser".constantize.new(
        workbasket_settings,
        current_step
      )
    end

    expose(:saver) do
      "::WorkbasketInteractions::#{sub_klass}::SettingsSaver".constantize.new(
        workbasket,
        current_step,
        saver_mode,
        settings_params
      )
    end

    def new
      self.workbasket = Workbaskets::Workbasket.create(
        type: settings_type,
        user: current_user
      )

      redirect_to initial_step_url
    end

    def update
      saver.save!

      if step_pointer.main_step?
        render json: saver.success_ops,
                     status: :ok

        return false
      end

      if saver.valid?
        handle_success_saving!
      else
        handle_errors!
      end
    end

    def destroy
      workbasket.clean_up_workbasket!

      redirect_to root_url
    end

    def move_to_editing_mode
      workbasket.move_status_to!(current_user, "editing")
      workbasket_settings.clean_up_temporary_data!

      redirect_to initial_step_url
    end

    def withdraw_workbasket_from_workflow
      move_to_editing_mode
    end

  private

    def require_step_declaration_in_params!
      if current_step.blank?
        redirect_to initial_step_url
        false
      end
    end

    def require_workbasket_to_be_new_in_progress!
      unless workbasket.new_in_progress?
        redirect_to root_url
        false
      end
    end

    def status_check!
      unless workbasket.editable?
        redirect_to read_only_section_url
        false
      end
    end

    def handle_submit_for_cross_check!
      if step_pointer.review_and_submit_step?
        workbasket.submit_for_cross_check!(current_admin: current_user)

        render json: { redirect_url: submitted_url },
               status: :ok

        false
      end
    end

    def handle_success_saving!
      workbasket_settings.track_step_validations_status!(current_step, true)
      saver.persist! if workbasket_data_can_be_persisted?

      render json: saver.success_ops,
             status: :ok
    end

    def handle_errors!
      workbasket_settings.track_step_validations_status!(current_step, false)

      render json: {
        step: current_step,
        errors: saver.errors,
        candidates_with_errors: saver.candidates_with_errors
      }, status: :unprocessable_entity
    end

    def clean_up_persisted_data_on_update!
      unless step_pointer.review_and_submit_step?
        workbasket_settings.clean_up_temporary_data!
      end
    end
  end
end
