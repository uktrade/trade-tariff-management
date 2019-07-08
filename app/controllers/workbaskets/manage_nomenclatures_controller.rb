module Workbaskets
  class ManageNomenclaturesController < ApplicationController

    expose(:sub_klass) { "ManageNomenclature" }
    expose(:settings_type) { :manage_nomenclature }

    expose(:settings_params) do
      ops = workbasket_params
      ops.send("permitted=", true) if ops.present?
      ops = (ops || {}).to_h
      ops
    end

    def new
      @nomenclature = GoodsNomenclature.find(goods_nomenclature_item_id: params[:item_id], producline_suffix: params[:suffix])
      @manage_nomenclature_form = WorkbasketForms::ManageNomenclatureForm.new(@nomenclature)
    end

    def create
      @workbasket = create_edit_nomenclature_workbasket

      redirect_to edit_edit_nomenclature_path(@workbasket.id)
    end

    private def create_edit_nomenclature_workbasket
      nomenclature = GoodsNomenclature.find(goods_nomenclature_item_id: workbasket_params[:item_id], producline_suffix: workbasket_params[:suffix])

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
          validity_start_date: extract_date_from_params(workbasket_params),
          original_nomenclature: find_original_nomenclature(workbasket_params[:original_nomenclature]).goods_nomenclature_sid
        )
      end
      workbasket
    end

    private def workbasket_params
      params.require(:workbasket_forms_manage_nomenclature_form).permit(:workbasket_name, :reason_for_changes, :description_validity_start_date, :original_nomenclature, :action)
    end

    private def extract_date_from_params(params)
      Date.new params["description_validity_start_date(1i)"].to_i, params["description_validity_start_date(2i)"].to_i, params["description_validity_start_date(3i)"].to_i
    end

    private def find_original_nomenclature(nomenclature_sid)
      GoodsNomenclature.find(goods_nomenclature_sid: nomenclature_sid)
    end

  end
end
