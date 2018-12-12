module Workbaskets
  class EditGeographicalAreaController < Workbaskets::BaseController
    skip_around_action :configure_time_machine, only: [:submitted_for_cross_check]

    expose(:sub_klass) { "EditGeographicalArea" }
    expose(:settings_type) { :edit_geographical_area }

    expose(:initial_step_url) do
      edit_edit_geographical_area_url(
        workbasket.id,
        step: :main
      )
    end

    expose(:read_only_section_url) do
      edit_geographical_area_url(workbasket.id)
    end

    expose(:submitted_url) do
      submitted_for_cross_check_edit_geographical_area_url(workbasket.id)
    end

    expose(:form) do
      WorkbasketForms::EditGeographicalAreaForm.new(original_geographical_area)
    end

    expose(:original_geographical_area) do
      workbasket_settings.original_geographical_area
                         .decorate
    end

    expose(:geographical_area) do
      workbasket_settings.updated_geographical_area
    end

    def new
      self.workbasket = Workbaskets::Workbasket.buld_new_workbasket!(
        settings_type, current_user
      )

      workbasket_settings.update(
        original_geographical_area_sid: params[:geographical_area_sid],
        original_geographical_area_id: params[:geographical_area_id]
      )

      redirect_to initial_step_url
    end

    def update
      saver.save!

      if saver.valid?
        workbasket_settings.track_step_validations_status!(current_step, true)

        if submit_for_cross_check_mode?
          saver.persist!
          submit_for_cross_check.run!

          render json: { redirect_url: submitted_url },
                 status: :ok
        else
          render json: saver.success_ops,
                       status: :ok
        end
      else
        workbasket_settings.track_step_validations_status!(current_step, false)

        render json: {
          step: current_step,
          errors_summary: saver.errors_summary,
          errors: saver.errors,
          conformance_errors: saver.conformance_errors
        }, status: :unprocessable_entity
      end
    end

  private

    def handle_validate_request!(validator)
      if validator.valid?
        render json: {},
               status: :ok
      else
        render json: {
          step: :main,
          errors: validator.errors
        }, status: :unprocessable_entity
      end
    end

    def check_if_action_is_permitted!
      true
    end

    def submit_for_cross_check_mode?
      params[:mode] == "submit_for_cross_check"
    end
  end
end
