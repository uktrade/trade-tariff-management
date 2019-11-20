module Workbaskets
  class CreateQuotaBlockingPeriodController < Workbaskets::BaseController
    skip_around_action :configure_time_machine, only: [:submitted_for_cross_check]

    expose(:sub_klass) { "CreateQuotaBlockingPeriod" }
    expose(:settings_type) { :create_quota_blocking_period }
    expose(:current_step) { "main" }
    expose(:previous_step_url) { quota_blocking_periods_url }
    expose(:initial_step_url) { edit_create_quota_blocking_period_url }

    respond_to :json

    def index
    end

    def new
      @create_quota_blocking_period_form = WorkbasketForms::CreateQuotaBlockingPeriodForm.new
    end

    def create
      @create_quota_blocking_period_form = WorkbasketForms::CreateQuotaBlockingPeriodForm.new(create_quota_blocking_period_params, current_user)

      if @create_quota_blocking_period_form.save
        redirect_to edit_create_quota_blocking_period_path(@create_quota_blocking_period_form.workbasket.id)
      else
        render :new
      end
    end

    def edit
      @edit_quota_blocking_period_form = WorkbasketForms::EditCreateQuotaBlockingPeriodForm.new(params[:id])
      @workbasket = Workbasket.find(id: params[:id])
    end

    def update
      byebug
      @edit_quota_blocking_period_form = WorkbasketForms::EditCreateQuotaBlockingPeriodForm.new(params[:id], update_quota_blocking_period_params)

      if @edit_quota_blocking_period_form.save
        redirect_to submitted_for_cross_check_create_quota_suspension_path(@edit_quota_suspension_form.workbasket.id)
      else
        render :edit
      end
    end

    private

      def create_quota_blocking_period_params
        params.require(:workbasket_forms_create_quota_blocking_period_form).permit(:workbasket_title, :workbasket_id, :quota_order_number_id)
      end

      def update_quota_blocking_period_params
        {
          quota_definition_sid: params[:quota_definition_sid],
          blocking_period_type: params[:blocking_period_type].to_i,
          description: params[:workbasket_forms_edit_create_quota_blocking_period_form][:description],
          start_date: params[:workbasket_forms_edit_create_quota_blocking_period_form][:start_date],
          end_date: params[:workbasket_forms_edit_create_quota_blocking_period_form][:end_date]
        }
      end

      def check_if_action_is_permitted!
        true
      end
  end
end
