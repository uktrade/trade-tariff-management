module Workbaskets
  class EditQuotaBlockingPeriodController < Workbaskets::BaseController
    skip_around_action :configure_time_machine, only: [:submitted_for_cross_check]

    expose(:sub_klass) { "EditQuotaBlockingPeriod" }
    expose(:settings_type) { :edit_quota_blocking_period }
    expose(:current_step) { "main" }
    expose(:previous_step_url) { quota_blocking_periods_url }
    expose(:initial_step_url) { edit_edit_quota_blocking_period_url }

    respond_to :json

    def index
    end

    def new
      @edit_quota_blocking_period_form = WorkbasketForms::EditQuotaBlockingPeriodForm.new
      @quota_blocking_period_sid = params[:quota_blocking_period_sid]
      @quota_definition = QuotaDefinition.find(quota_definition_sid: params[:quota_definition_sid])
    end

    def create
      @quota_definition = QuotaDefinition.find(quota_definition_sid: params[:quota_definition_sid])
      @quota_blocking_period_sid = params[:quota_blocking_period_sid]
      @edit_quota_blocking_period_form = WorkbasketForms::EditQuotaBlockingPeriodForm.new(edit_quota_blocking_period_params, current_user)

      if @edit_quota_blocking_period_form.save
        redirect_to edit_edit_quota_blocking_period_path(id: @edit_quota_blocking_period_form.workbasket.id, quota_blocking_period_sid: params[:quota_blocking_period_sid], quota_definition_sid: params[:quota_definition_sid])
      else
        render :action => 'new'
      end
    end

    def edit
      @workbasket = Workbasket.find(id: params[:id])
      @quota_blocking_period = QuotaBlockingPeriod.find(quota_blocking_period_sid: @workbasket.settings.quota_blocking_period_sid)
      @quota_definition = QuotaDefinition.find(quota_definition_sid: @workbasket.settings.quota_definition_sid)
      @edit_edit_quota_blocking_period_form = WorkbasketForms::EditEditQuotaBlockingPeriodForm.new(params[:id])
    end

    def update
      @quota_definition = QuotaDefinition.find(quota_definition_sid: params[:quota_definition_sid])
      @quota_blocking_period_sid = params[:quota_blocking_period_sid]
      @quota_blocking_period = QuotaBlockingPeriod.find(quota_blocking_period_sid: params[:quota_blocking_period_sid])
      @edit_edit_quota_blocking_period_form = WorkbasketForms::EditEditQuotaBlockingPeriodForm.new(params[:id], update_quota_blocking_period_params)

      if @edit_edit_quota_blocking_period_form.save
        redirect_to submitted_for_cross_check_edit_quota_blocking_period_path(@edit_edit_quota_blocking_period_form.workbasket.id)
      else
        render :action => 'edit'
      end
    end

    private
      def check_if_action_is_permitted!
        true
      end

      def edit_quota_blocking_period_params
        {
          workbasket_title: params[:workbasket_forms_edit_quota_blocking_period_form][:workbasket_title],
          quota_order_number_id: params[:workbasket_forms_edit_quota_blocking_period_form][:quota_order_number_id],
          quota_blocking_period_sid: params[:quota_blocking_period_sid],
          quota_definition_sid: params[:quota_definition_sid]
        }
      end

      def update_quota_blocking_period_params
        {
          quota_definition_sid: params[:quota_definition_sid],
          blocking_period_type: params[:blocking_period_type].to_i,
          description: params[:workbasket_forms_edit_edit_quota_blocking_period_form][:description],
          start_date: params[:workbasket_forms_edit_edit_quota_blocking_period_form][:start_date],
          quota_blocking_period_sid: params[:quota_blocking_period_sid],
          end_date: params[:workbasket_forms_edit_edit_quota_blocking_period_form][:end_date]
        }
      end
  end
end
