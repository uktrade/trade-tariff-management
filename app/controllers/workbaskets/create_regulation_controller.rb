module Workbaskets
  class CreateRegulationController < Workbaskets::BaseController

    expose(:sub_klass) { "CreateRegulation" }
    expose(:settings_type) { :create_regulation }

    expose(:initial_step_url) do
      edit_create_regulation_url(
          workbasket.id,
          step: :main
      )
    end

    expose(:previous_step_url) do
      edit_create_regulation_url(
          workbasket.id,
          step: previous_step
      )
    end

    expose(:read_only_section_url) do
      create_regulation_url(workbasket.id)
    end

    expose(:submitted_url) do
      create_regulation_url(workbasket.id)
    end

    def update
      saver.save!
      if saver.valid?
        handle_success_saving!
      else
        handle_errors!
      end
    end

    def attach_pdf
      ::WorkbasketInteractions::CreateRegulation::SettingsSaver.attach_pdf_to!(
        params[:workbasket_forms_create_regulation_form][:pdf_data],
        workbasket
      )

      head :ok
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
