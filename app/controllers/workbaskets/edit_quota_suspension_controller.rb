module Workbaskets
  class EditQuotaSuspensionController < Workbaskets::BaseController
    skip_around_action :configure_time_machine, only: [:submitted_for_cross_check]

    expose(:sub_klass) { "EditQuotaSuspension" }
    expose(:settings_type) { :edit_quota_suspension }
    expose(:current_step) { "main" }
    expose(:previous_step_url) { quota_suspensions_url }
    expose(:initial_step_url) { edit_quota_suspension_url }

    respond_to :json

    def index
    end

    def new
      @edit_quota_suspension_form = WorkbasketForms::EditQuotaSuspensionForm.new
      @quota_suspension_period_sid = params[:quota_suspension_period_sid]
      @quota_definition = QuotaDefinition.find(quota_definition_sid: params[:quota_definition_sid])
    end

    def create
      @quota_definition = QuotaDefinition.find(quota_definition_sid: params[:quota_definition_sid])
      @quota_suspension_period_sid = params[:quota_suspension_period_sid]
      @edit_quota_suspension_form = WorkbasketForms::EditQuotaSuspensionForm.new(edit_quota_suspension_params, current_user)

      if @edit_quota_suspension_form.save
        redirect_to edit_edit_quota_suspension_path(id: @edit_quota_suspension_form.workbasket.id, quota_suspension_period_sid: params[:quota_suspension_period_sid], quota_definition_sid: params[:quota_definition_sid])
      else
        render :action => 'new'
      end
    end

    def edit
      @workbasket = Workbasket.find(id: params[:id])
      @quota_suspension_period = params[:quota_suspension_period_sid] ? QuotaSuspensionPeriod.find(quota_suspension_period_sid: params[:quota_suspension_period_sid]) : QuotaSuspensionPeriod.find(quota_suspension_period_sid: @workbasket.settings.quota_suspension_period_sid)
      @quota_definition = params[:quota_definition_sid] ? QuotaDefinition.find(quota_definition_sid: params[:quota_definition_sid]) : QuotaDefinition.find(quota_definition_sid: @workbasket.settings.quota_definition_sid)
      @edit_edit_quota_suspension_form = WorkbasketForms::EditEditQuotaSuspensionForm.new(params[:id])
    end

    def update
      @quota_definition = QuotaDefinition.find(quota_definition_sid: params[:quota_definition_sid])
      @quota_suspension_period_sid = params[:quota_suspension_period_sid]
      @quota_suspension_period = QuotaSuspensionPeriod.find(quota_suspension_period_sid: params[:quota_suspension_period_sid])
      @edit_edit_quota_suspension_form = WorkbasketForms::EditEditQuotaSuspensionForm.new(params[:id], update_quota_suspension_params)

      if @edit_edit_quota_suspension_form.save
        redirect_to submitted_for_cross_check_edit_quota_suspension_path(@edit_edit_quota_suspension_form.workbasket.id)
      else
        render :action => 'edit'
      end
    end

    private
      def check_if_action_is_permitted!
        true
      end

      def edit_quota_suspension_params
        {
          workbasket_title: params[:workbasket_forms_edit_quota_suspension_form][:workbasket_title],
          quota_order_number_id: params[:workbasket_forms_edit_quota_suspension_form][:quota_order_number_id],
          quota_suspension_period_sid: params[:quota_suspension_period_sid],
          quota_definition_sid: params[:quota_definition_sid]
        }
      end

      def update_quota_suspension_params
        {
          quota_definition_sid: params[:quota_definition_sid],
          description: params[:workbasket_forms_edit_edit_quota_suspension_form][:description],
          start_date: params[:workbasket_forms_edit_edit_quota_suspension_form][:start_date],
          end_date: params[:workbasket_forms_edit_edit_quota_suspension_form][:end_date],
          quota_suspension_period_sid: params[:quota_suspension_period_sid]
        }
      end
  end
end
