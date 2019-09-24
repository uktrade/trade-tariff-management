module Workbaskets
  class EditRegulationController < Workbaskets::BaseController
    skip_around_action :configure_time_machine, only: [:submitted_for_cross_check]

    expose(:sub_klass) { "EditRegulation" }
    expose(:settings_type) { :edit_regulation }
    expose(:current_step) { "main" }

    expose(:initial_step_url) do
      edit_edit_regulation_url(
        workbasket.id,
        step: :main
      )
    end
    #
    expose(:read_only_section_url) do
      edit_regulation_url(workbasket.id)
    end

    #
    expose(:submitted_url) do
      submitted_for_cross_check_edit_regulation_url(workbasket.id)
    end

    expose(:form) do
      WorkbasketForms::EditRegulationForm.new(workbasket_settings)
    end

    expose(:original_regulation) do
      find_regulation(workbasket.settings.original_base_regulation_id, workbasket.settings.original_base_regulation_role).decorate
    end

    expose(:regulation) do
      find_regulation(workbasket.settings.base_regulation_id, workbasket.settings.original_base_regulation_role).decorate
    end


    def new
      self.workbasket = Workbaskets::Workbasket.create(
        type: settings_type,
        title: params[:base_regulation_id],
        user: current_user
      )
      workbasket_settings.update(
        original_base_regulation_id: params[:base_regulation_id],
        original_base_regulation_role: params[:base_regulation_role]
      )

      workbasket_settings.update(
        base_regulation_id: original_regulation.base_regulation_id,
        legal_id: original_regulation.legal_id,
        description: original_regulation.description,
        reference_url: original_regulation.reference_url,
        validity_start_date: original_regulation.validity_start_date,
        validity_end_date: original_regulation.validity_end_date,
        regulation_group_id: original_regulation.regulation_group_id
      )

      redirect_to initial_step_url
    end

    def edit
      @edit_regulation_form = WorkbasketForms::EditRegulationForm.new(workbasket.settings)
    end

    def update
      params[:settings] = params[:workbasket_forms_edit_regulation_form]
      if saver.save!

        workbasket.submit_for_cross_check!(current_admin: current_user)
        redirect_to submitted_for_cross_check_edit_regulation_url(workbasket.id)
      else
        @edit_regulation_form = WorkbasketForms::EditRegulationForm.new(workbasket.settings)
        render :edit, locals: { errors: saver.errors, errors_summary: saver.errors_summary }
      end
    end

  private

    def check_if_action_is_permitted!
      true
    end

    def find_regulation(regulation_id, role)
      BaseRegulation.find(base_regulation_id: regulation_id, base_regulation_role: role)
    end

  end
end
