module Workbaskets
  class CreateQuotaSuspensionController < Workbaskets::BaseController
    skip_around_action :configure_time_machine, only: [:submitted_for_cross_check]

    expose(:sub_klass) { "CreateQuotaSuspension" }
    expose(:settings_type) { :create_quota_suspension }
    expose(:current_step) { "main" }
    expose(:previous_step_url) { quota_suspensions_url }
    expose(:initial_step_url) { edit_create_quota_suspension_url }

    respond_to :json

    def index
    end

    def new
      @create_quota_suspension_form = WorkbasketForms::CreateQuotaSuspensionForm.new
    end

    def create
      @create_quota_suspension_form = WorkbasketForms::CreateQuotaSuspensionForm.new(create_quota_suspension_params, current_user)

      if @create_quota_suspension_form.save
        redirect_to edit_create_quota_suspension_path(@create_quota_suspension_form.workbasket.id)
      else
        render :new
      end
    end

    def edit
      @edit_quota_suspension_form = WorkbasketForms::EditQuotaSuspensionForm.new(params[:id])
      @workbasket = Workbasket.find(id: params[:id])
    end

    def update
      @edit_quota_suspension_form = WorkbasketForms::EditQuotaSuspensionForm.new(params[:id], update_quota_suspension_params)

      if @edit_quota_suspension_form.save
        redirect_to submitted_for_cross_check_create_quota_suspension_path(@edit_quota_suspension_form.workbasket.id)
      else
        render :edit
      end
    end

    private

      def create_quota_suspension_params
        params.require(:workbasket_forms_create_quota_suspension_form).permit(:workbasket_title, :workbasket_id, :quota_order_number_id)
      end

      def update_quota_suspension_params
        {
          quota_definition_sid: params[:quota_definition_sid],
          description: params[:workbasket_forms_edit_quota_suspension_form][:description],
          start_date: params[:workbasket_forms_edit_quota_suspension_form][:start_date],
          end_date: params[:workbasket_forms_edit_quota_suspension_form][:end_date]
        }
      end


      def check_if_action_is_permitted!
        true
      end
  end
end
