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
    end

    def create
      @create_quota_suspension_form = WorkbasketForms::EditQuotaSuspensionForm.new(edit_quota_suspension_params, current_user)

      if @create_quota_suspension_form.save
        redirect_to edit_create_quota_suspension_path(@create_quota_suspension_form.workbasket.id)
      else
        render :new
      end
    end

    private
      def check_if_action_is_permitted!
        true
      end
  end
end
