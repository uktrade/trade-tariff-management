
module Workbaskets
  class DeleteQuotaAssociationController < Workbaskets::BaseController
    skip_around_action :configure_time_machine, only: [:submitted_for_cross_check]

    expose(:sub_klass) { "DeleteQuotaAssociations" }
    expose(:settings_type) { :delete_quota_association }
    expose(:current_step) { "main" }
    expose(:previous_step_url) { delete_quota_associations_url }
    expose(:initial_step_url) { delete_quota_association_url }

    respond_to :json

    def new
      @delete_quota_association_form = WorkbasketForms::DeleteQuotaAssociationForm.new(settings: new_delete_quota_association_params)
    end

    def create
      @delete_quota_association_form = WorkbasketForms::DeleteQuotaAssociationForm.new(settings: create_delete_quota_association_params, current_user: current_user)

      if @delete_quota_association_form.create
        redirect_to submitted_for_cross_check_delete_quota_association_path(@delete_quota_association_form.workbasket.id)
      else
        render :new
      end
    end

    def new_delete_quota_association_params
      params.permit(:main_quota_definition_sid, :sub_quota_definition_sid)
    end

    def create_delete_quota_association_params
      params.require(:workbasket_forms_delete_quota_association_form).permit(:workbasket_title, :reason_for_changes, :main_quota_definition_sid, :sub_quota_definition_sid)
    end

    def check_if_action_is_permitted!
      true
    end

  end
end
