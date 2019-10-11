
module Workbaskets
  class CreateQuotaAssociationController < Workbaskets::BaseController
    skip_around_action :configure_time_machine, only: [:submitted_for_cross_check]

    expose(:sub_klass) { "CreateQuotaAssociation" }
    expose(:settings_type) { :create_quota_association }
    expose(:current_step) { "main" }
    expose(:previous_step_url) { quota_associations_url }
    expose(:initial_step_url) { edit_create_quota_association_url }

    respond_to :json

    def index
    end

    def new
      @create_quota_association_form = WorkbasketForms::CreateQuotaAssociationForm.new
    end

    def create
      @create_quota_association_form = WorkbasketForms::CreateQuotaAssociationForm.new(create_quota_association_params, current_user)

      if @create_quota_association_form.save
        redirect_to edit_create_quota_association_path(@create_quota_association_form.workbasket.id)
      else
        render :new
      end
    end

    def edit
      @edit_quota_association_form = WorkbasketForms::EditQuotaAssociationForm.new(params[:id])
      @workbasket = Workbasket.find(id: params[:id])
    end

    def update
      @edit_quota_association_form = WorkbasketForms::EditQuotaAssociationForm.new(params[:id], update_quota_association_params)

      if @edit_quota_association_form.save
        redirect_to submitted_for_cross_check_create_quota_association_path(@edit_quota_association_form.workbasket.id)
      else
        render :edit
      end
    end

    def search
      if(params.has_key?(:parent_quota) && params.has_key?(:child_quota))
        redirect_to new_create_quota_association_url
      end
    end

    private def association_params
      params.require(:create_quota_association_form).permit(:workbasket_title, :parent_order_id, :child_order_id)
    end

    def create_quota_association_params
      params.require(:workbasket_forms_create_quota_association_form).permit(:workbasket_title, :parent_order_id, :child_order_id)
    end

    def update_quota_association_params
      params.permit(:parent_definition_period, :child_definition_period, :relation_type, :coefficient)
    end

    def check_if_action_is_permitted!
      true
    end

  end
end
