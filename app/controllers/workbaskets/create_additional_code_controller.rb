module Workbaskets
  class CreateAdditionalCodeController < Workbaskets::BaseController

    expose(:sub_klass) { "CreateAdditionalCode" }
    expose(:settings_type) { :create_additional_code }

    expose(:initial_step_url) do
      edit_create_additional_code_url(
          workbasket.id,
          step: :main
      )
    end

    expose(:previous_step_url) do
      edit_create_additional_code_url(
          workbasket.id,
          step: previous_step
      )
    end

    expose(:read_only_section_url) do
      create_additional_code_url(workbasket.id)
    end

    expose(:submitted_url) do
      submitted_for_cross_check_create_additional_code_url(workbasket.id)
    end

    def update
      saver.save!
      if saver.valid?
        workbasket_settings.track_step_validations_status!(current_step, true)
        saver.persist!

        submit_for_cross_check.run!

        render json: { redirect_url: submitted_url },
               status: :ok
      else
        handle_errors!
      end
    end

    private

    def check_if_action_is_permitted!
      true
    end

    def workbasket_data_can_be_persisted?
      true
    end

  end
end
