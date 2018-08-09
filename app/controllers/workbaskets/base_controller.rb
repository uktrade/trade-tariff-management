module Workbaskets
  class BaseController < Measures::BulksBaseController

    around_action :configure_time_machine

    before_action :require_to_be_workbasket_owner!,
                  :require_step_declaration_in_params!,
                  :check_if_action_is_permitted!,
                  :status_check!, only: [ :edit, :update ]

    before_action :clean_up_persisted_data_on_update!,
                  :handle_submit_for_cross_check!, only: [:update]


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
      ops.send("permitted=", true)
      ops = ops.to_h

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

    expose(:submit_for_cross_check) do
      "::WorkbasketInteractions::#{sub_klass}::SubmitForCrossCheck".constantize.new(
        workbasket
      )
    end

    def new
      self.workbasket = Workbaskets::Workbasket.buld_new_workbasket!(
        settings_type, current_user
      )

      redirect_to initial_step_url
    end

    def update
      saver.save!

      if step_pointer.main_step? && saver_mode == "continue"
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

    private

      def require_step_declaration_in_params!
        if current_step.blank?
          redirect_to initial_step_url
          return false
        end
      end

      def status_check!
        unless workbasket.new_in_progress?
          redirect_to read_only_section_url
          return false
        end
      end

      def handle_submit_for_cross_check!
        if step_pointer.review_and_submit_step?
          submit_for_cross_check.run!

          render json: { redirect_url: read_only_section_url },
                 status: :ok

          return false
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
        if !step_pointer.review_and_submit_step? &&
           workbasket.type == "create_measures"

          workbasket_settings.collection.map(&:destroy) # TODO: refactor it Ruslan
        end
      end
  end
end
