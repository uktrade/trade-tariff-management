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
      if (workbasket_params[:action] == 'new_nomenclature')
        @workbasket = create_create_nomenclature_workbasket
        redirect_to edit_create_nomenclature_path(@workbasket.id)
      elsif (workbasket_params[:action] == 'edit_nomenclature')
        @workbasket = create_edit_nomenclature_workbasket
        redirect_to edit_edit_nomenclature_path(@workbasket.id)
      elsif (workbasket_params[:action] == 'edit_nomenclature_dates')
        @workbasket = create_edit_nomenclature_dates_workbasket
        redirect_to edit_edit_nomenclature_date_path(@workbasket.id)
      end
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
        original_nomenclature = find_original_nomenclature(workbasket_params[:original_nomenclature])
        workbasket.settings.update(
          workbasket_id: workbasket.id,
          workbasket_name: workbasket_params[:workbasket_name],
          reason_for_changes: workbasket_params[:reason_for_changes],
          original_nomenclature: original_nomenclature.goods_nomenclature_sid,
          original_description: original_nomenclature.description
        )
      end
      workbasket
    end

    private def create_edit_nomenclature_dates_workbasket
      nomenclature = GoodsNomenclature.find(goods_nomenclature_item_id: workbasket_params[:item_id], producline_suffix: workbasket_params[:suffix])

      workbasket = Workbaskets::Workbasket.new(
        title: workbasket_params[:workbasket_name],
        status: :new_in_progress,
        type: :edit_nomenclature_dates,
        user: current_user
      )

      if workbasket.save
        original_nomenclature = find_original_nomenclature(workbasket_params[:original_nomenclature])
        workbasket.settings.update(
          workbasket_id: workbasket.id,
          workbasket_name: workbasket_params[:workbasket_name],
          reason_for_changes: workbasket_params[:reason_for_changes],
          original_nomenclature: original_nomenclature.goods_nomenclature_sid,
          validity_start_date: original_nomenclature.validity_start_date,
          validity_end_date: original_nomenclature.validity_end_date
        )
      end
      workbasket
    end

    private def create_create_nomenclature_workbasket
      nomenclature = GoodsNomenclature.find(goods_nomenclature_item_id: workbasket_params[:item_id], producline_suffix: workbasket_params[:suffix])

      workbasket = Workbaskets::Workbasket.new(
        title: workbasket_params[:workbasket_name],
        status: :new_in_progress,
        type: :create_nomenclature,
        user: current_user
      )

      if workbasket.save
        original_nomenclature = find_original_nomenclature(workbasket_params[:original_nomenclature])
        workbasket.settings.update(
          workbasket_id: workbasket.id,
          workbasket_name: workbasket_params[:workbasket_name],
          reason_for_changes: workbasket_params[:reason_for_changes],
          parent_nomenclature_sid: original_nomenclature.goods_nomenclature_sid
        )
      end
      workbasket
    end

    private def workbasket_params
      params.require(:workbasket_forms_manage_nomenclature_form).permit(:workbasket_name, :reason_for_changes, :description_validity_start_date, :original_nomenclature, :action)
    end

    private def find_original_nomenclature(nomenclature_sid)
      GoodsNomenclature.find(goods_nomenclature_sid: nomenclature_sid)
    end

  end
end
