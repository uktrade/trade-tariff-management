module Workbaskets
  class CreateNomenclatureController < Workbaskets::BaseController
    skip_around_action :configure_time_machine, only: [:submitted_for_cross_check]

    expose(:sub_klass) { "CreateNomenclature" }
    expose(:settings_type) { :create_nomenclature }
    expose(:current_step) { "main" }

    expose(:initial_step_url) do
      edit_create_nomenclature_url(
        workbasket.id,
        step: :main
      )
    end
    #
    expose(:read_only_section_url) do
      create_nomenclature_url(workbasket.id)
    end

    #
    expose(:submitted_url) do
      submitted_for_cross_check_create_nomenclature_url(workbasket.id)
    end

    expose(:form) do
      WorkbasketForms::CreateNomenclatureForm.new(original_nomenclature)
    end

    expose(:original_nomenclature) do
      find_original_nomenclature(workbasket.settings.parent_nomenclature_sid)
    end

    def edit
      @create_nomenclature_form = WorkbasketForms::CreateNomenclatureForm.new(original_nomenclature, workbasket.settings)
    end

    def update
      params[:settings] = params[:workbasket_forms_create_nomenclature_form]
      saver.save!
      if saver.errors.any?
        @create_nomenclature_form = WorkbasketForms::CreateNomenclatureForm.new(original_nomenclature, workbasket.settings)
        render :edit
      else
        workbasket.submit_for_cross_check!(current_admin: current_user)
        redirect_to submitted_for_cross_check_create_nomenclature_url(workbasket.id)
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
