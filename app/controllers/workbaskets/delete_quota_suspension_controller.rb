module Workbaskets
  class DeleteQuotaSuspensionController < Workbaskets::BaseController
    skip_around_action :configure_time_machine, only: [:submitted_for_cross_check]

    expose(:sub_klass) { "DeleteQuotaSuspension" }
    expose(:settings_type) { :delete_quota_suspension }
    expose(:current_step) { "main" }
    expose(:previous_step_url) { quota_suspensions_url }
    expose(:initial_step_url) { delete_quota_suspension_url }

    respond_to :json

    def index
    end

    def new
      @delete_quota_suspension_form = WorkbasketForms::DeleteQuotaSuspensionForm.new
      @quota_suspension_period_sid = params[:quota_suspension_period_sid]
      @quota_definition = QuotaDefinition.find(quota_definition_sid: params[:quota_definition_sid])
    end

    def create
      @quota_definition = QuotaDefinition.find(quota_definition_sid: params[:quota_definition_sid])
      @quota_suspension_period_sid = params[:quota_suspension_period_sid]

      @delete_quota_suspension_form = WorkbasketForms::DeleteQuotaSuspensionForm.new(settings: delete_quota_suspension_params, current_user: current_user)

      if @delete_quota_suspension_form.save
        redirect_to submitted_for_cross_check_delete_quota_suspension_path(@delete_quota_suspension_form.workbasket.id)
      else
        render :action => 'new'
      end
    end

    private
      def check_if_action_is_permitted!
        true
      end

      def delete_quota_suspension_params
        params.require(:workbasket_forms_delete_quota_suspension_form).permit(:workbasket_title, :reason_for_changes, :quota_suspension_period_sid)
      end
  end
end
