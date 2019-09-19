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
      WorkbasketForms::EditRegulationForm.new(original_regulation)
    end

    expose(:original_regulation) do
      find_original_regulation(workbasket.settings.original_base_regulation_id, workbasket.settings.original_base_regulation_role)
    end

    def new
      self.workbasket = Workbaskets::Workbasket.create(
        type: settings_type,
        user: current_user
      )

      workbasket_settings.update(
        validity_start_date: Date.today,
        original_base_regulation_id: params[:base_regulation_id],
        original_base_regulation_role: params[:base_regulation_role]
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
        render :edit
      end
    end

  private

    def check_if_action_is_permitted!
      true
    end

    def find_original_regulation(regulation_id, role)
      BaseRegulation.find(base_regulation_id: regulation_id, base_regulation_role: role)
    end

  end
end
