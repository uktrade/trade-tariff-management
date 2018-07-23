module Workbaskets
  class CreateMeasuresController < Measures::BulksBaseController

    before_action :require_to_be_workbasket_owner!,
                  :require_step_declaration_in_params!,
                  :check_if_action_is_permitted!, only: [ :edit, :update ]

    expose(:current_step) { params[:step] }

    expose(:step_pointer) do
      ::CreateMeasures::StepPointer.new(current_step)
    end

    expose(:previous_step) do
      step_pointer.previous_step
    end

    expose(:workbasket_settings) do
      workbasket.create_measures_settings
    end

    expose(:settings_params) do
      ops = params[:settings]
      ops.send("permitted=", true)
      ops = ops.to_h

      ops
    end

    expose(:saver) do
      Workbaskets::CreateMeasures::SettingsSaver.new(
        workbasket,
        current_step,
        settings_params
      )
    end

    expose(:form) do
      Workbaskets::CreateMeasures::Form.new(
        Measure.new
      )
    end

    expose(:attributes_parser) do
      ::CreateMeasures::AttributesParser.new(
        workbasket_settings,
        current_step
      )
    end

    expose(:submit_for_cross_check) do
      ::Workbaskets::CreateMeasures::SubmitForCrossCheck.new(
        workbasket
      )
    end

    def new
      self.workbasket = Workbaskets::Workbasket.buld_new_workbasket!(
        :create_measures, current_user
      )

      redirect_to edit_create_measure_url(
        workbasket.id,
        step: :main
      )
    end

    def update
      if step_pointer.review_and_submit_step?
        submit_for_cross_check.run!

        render json: { redirect_url: create_measure_url(workbasket.id) },
               status: :ok

        return false
      end

      saver.save!

      if saver.valid?
        workbasket_settings.track_step_validations_status!(current_step, true)

        if step_pointer.duties_conditions_footnotes? && params[:mode] == 'continue'
          saver.persist!
        end

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

    private

      def require_step_declaration_in_params!
        if current_step.blank?
          redirect_to edit_create_measure_url(
            workbasket.id,
            step: :main
          )

          return false
        end
      end

      def check_if_action_is_permitted!
        if current_step != 'main' &&
           !workbasket_settings.validations_passed?(previous_step)

          redirect_to edit_create_measure_url(
            workbasket.id,
            step: previous_step
          )

          return false
        end
      end
  end
end
