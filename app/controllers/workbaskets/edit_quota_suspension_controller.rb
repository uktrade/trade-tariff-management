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
      @quota_order_number = params[:quota_order_number]
    end

    def create
      @edit_quota_suspension_form = WorkbasketForms::EditQuotaSuspensionForm.new(edit_quota_suspension_params, current_user)
      if @edit_quota_suspension_form.save
        redirect_to edit_edit_quota_suspension_path(@edit_quota_suspension_form.workbasket.id)
      else
        render :new
      end
    end

    def edit
      @edit_edit_quota_suspension_form = WorkbasketForms::EditEditQuotaSuspensionForm.new(params[:id])
      @workbasket = Workbasket.find(id: params[:id])
    end

    private
      def check_if_action_is_permitted!
        true
      end

      def edit_quota_suspension_params
        params.require(:workbasket_forms_edit_quota_suspension_form).permit(:workbasket_title, :workbasket_id, :quota_order_number_id)
      end
  end
end
