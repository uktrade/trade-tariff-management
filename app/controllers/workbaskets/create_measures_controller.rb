module Workbaskets
  class CreateMeasuresController < Workbaskets::BaseController

    expose(:sub_klass) { "CreateMeasures" }
    expose(:settings_type) { :create_measures }

    expose(:initial_step_url) do
      edit_create_measure_url(
        workbasket.id,
        step: :main
      )
    end

    expose(:previous_step_url) do
      edit_create_measure_url(
        workbasket.id,
        step: previous_step
      )
    end

    expose(:read_only_section_url) do
      create_measure_url(workbasket.id)
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

      def check_if_action_is_permitted!
        if step_pointer.review_and_submit_step? &&
           !workbasket_settings.validations_passed?(previous_step)

          redirect_to previous_step_url
          return false
        end
      end

      def handle_success_saving!
        workbasket_settings.track_step_validations_status!(current_step, true)

        if step_pointer.duties_conditions_footnotes? && saver_mode == 'continue'
          saver.persist!
        end

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
  end
end
