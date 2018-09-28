module Workbaskets
  class CreateGeographicalAreaController < Workbaskets::BaseController

    expose(:sub_klass) { "CreateGeographicalArea" }
    expose(:settings_type) { :create_geographical_area }

    expose(:initial_step_url) do
      edit_create_geographical_area_url(
        workbasket.id,
        step: :main
      )
    end

    expose(:previous_step_url) do
      edit_create_geographical_area_url(
        workbasket.id,
        step: previous_step
      )
    end

    expose(:read_only_section_url) do
      create_geographical_area_url(workbasket.id)
    end

    expose(:submitted_url) do
      create_geographical_area_url(workbasket.id)
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
      ::WorkbasketInteractions::CreateGeographicalArea::SettingsSaver.attach_pdf_to!(
        params[:workbasket_forms_create_geographical_area_form][:pdf_data],
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
