module Workbaskets
  class EditNomenclatureController < Workbaskets::BaseController
    skip_around_action :configure_time_machine, only: [:submitted_for_cross_check]

    expose(:sub_klass) { "EditNomenclature" }
    expose(:settings_type) { :edit_nomenclature }
    expose(:current_step) { "main" }

    expose(:initial_step_url) do
      edit_edit_nomenclature_url(
        workbasket.id,
        step: :main
      )
    end
    #
    expose(:read_only_section_url) do
      edit_nomenclature_url(workbasket.id)
    end

    #
    expose(:submitted_url) do
      submitted_for_cross_check_edit_nomenclature_url(workbasket.id)
    end

    expose(:form) do
      WorkbasketForms::EditNomenclatureForm.new(original_nomenclature)
    end

    expose(:original_nomenclature) do
      find_original_nomenclature(workbasket_settings.original_nomenclature)
    end

    def new
      self.workbasket = Workbaskets::Workbasket.create(
        type: settings_type,
        user: current_user
      )

      workbasket_settings.update(
        original_nomenclature_id: params[:nomenclature_id]
      )

      redirect_to initial_step_url
    end

    def edit
      @edit_nomenclature_form = WorkbasketForms::EditNomenclatureForm.new(original_nomenclature)
    end

    def update
      params[:settings] = params[:workbasket_forms_edit_nomenclature_form]
      saver.save!

      workbasket.submit_for_cross_check!(current_admin: current_user)
      redirect_to submitted_for_cross_check_edit_nomenclature_url(workbasket.id)
    end

  private

    def check_if_action_is_permitted!
      true
    end

    def update_edit_nomenclature_workbasket

      workbasket = Workbasket::Ed

      workbasket = Workbaskets::Workbasket.new(
        title: workbasket_params[:workbasket_name],
        status: :new_in_progress,
        type: :edit_nomenclature,
        user: current_user
      )

      if workbasket.save
        workbasket.settings.update(
          workbasket_id: workbasket.id,
          workbasket_name: workbasket_params[:workbasket_name],
          reason_for_changes: workbasket_params[:reason_for_changes],
          validity_start_date: extract_date_from_params(workbasket_params)
        )
      end
      workbasket
    end

    private def find_original_nomenclature(nomenclature_sid)
      GoodsNomenclature.find(goods_nomenclature_sid: nomenclature_sid)
    end

  end
end
