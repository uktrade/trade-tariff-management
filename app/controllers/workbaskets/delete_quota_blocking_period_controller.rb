module Workbaskets
  class DeleteQuotaBlockingPeriodController < Workbaskets::BaseController
    skip_around_action :configure_time_machine, only: [:submitted_for_cross_check]

    expose(:sub_klass) { "DeleteQuotaBlockingPeriod" }
    expose(:settings_type) { :delete_quota_blocking_period }
    expose(:current_step) { "main" }
    expose(:previous_step_url) { quota_blocking_periods_url }
    expose(:initial_step_url) { delete_quota_blocking_period_url }

    respond_to :json

    def index
    end

    def new
      @delete_quota_blocking_period_form = WorkbasketForms::DeleteQuotaBlockingPeriodForm.new
      @quota_blocking_period_sid = params[:quota_blocking_period_sid]
      @quota_definition = QuotaDefinition.find(quota_definition_sid: params[:quota_definition_sid])
    end

    def create
      @quota_definition = QuotaDefinition.find(quota_definition_sid: quota_definition_sid)
      @quota_blocking_period_sid = quota_blocking_period_sid

      @delete_quota_blocking_period_form = WorkbasketForms::DeleteQuotaBlockingPeriodForm.new(settings: delete_quota_blocking_period_params, current_user: current_user)

      if @delete_quota_blocking_period_form.save
        redirect_to submitted_for_cross_check_delete_quota_blocking_period_path(@delete_quota_blocking_period_form.workbasket.id)
      else
        render :action => 'new'
      end
    end

    private
      def check_if_action_is_permitted!
        true
      end

      def quota_definition_sid
        params[:quota_definition_sid] ? params[:quota_definition_sid] : params[:workbasket_forms_delete_quota_blocking_period_form][:quota_definition_sid]
      end

      def quota_blocking_period_sid
        params[:quota_blocking_period_sid] ? params[:quota_blocking_period_sid] : params[:workbasket_forms_delete_quota_blocking_period_form][:quota_blocking_period_sid]
      end

      def delete_quota_blocking_period_params
        params.require(:workbasket_forms_delete_quota_blocking_period_form).permit(:workbasket_title, :reason_for_changes, :quota_blocking_period_sid)
      end
  end
end
