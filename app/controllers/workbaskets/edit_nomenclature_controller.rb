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
      find_original_nomenclature(workbasket.settings.original_nomenclature)
    end

    def new
      self.workbasket = Workbaskets::Workbasket.create(
        type: settings_type,
        user: current_user
      )

      redirect_to initial_step_url
    end

    def edit
      @edit_nomenclature_form = WorkbasketForms::EditNomenclatureForm.new(original_nomenclature, workbasket.settings)
    end

    def update
      params[:settings] = params[:workbasket_forms_edit_nomenclature_form]
      if saver.save!

        workbasket.submit_for_cross_check!(current_admin: current_user)
        redirect_to submitted_for_cross_check_edit_nomenclature_url(workbasket.id)
      else
        @edit_nomenclature_form = WorkbasketForms::EditNomenclatureForm.new(original_nomenclature, workbasket.settings)
        render :edit
      end
    end

  private

    def check_if_action_is_permitted!
      true
    end

    def find_original_nomenclature(nomenclature_sid)
      GoodsNomenclature.find(goods_nomenclature_sid: nomenclature_sid)
    end

  end
end
