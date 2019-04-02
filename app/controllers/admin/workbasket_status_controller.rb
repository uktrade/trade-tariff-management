module Admin
  class WorkbasketStatusController < ApplicationController

    around_action :configure_time_machine

    def index
      @workbaskets = Workbaskets::Workbasket.in_status(%w[awaiting_cds_upload_create_new awaiting_cds_upload_edit sent_to_cds]).default_order
    end

    def update
      workbasket = Workbaskets::Workbasket[params[:id]]
      new_status = params[:status]
      if allowed_status(new_status) && workbasket.testing_status_backdoor!(current_admin: current_user, status: new_status)
        flash[:notice] = "Workbasket '#{workbasket.id}' status is now '#{workbasket.status}'"
      else
        flash[:notice] = "Status was not changed!"
      end
      redirect_to admin_workbasket_status_index_url
    end

    private

    def allowed_status(new_status)
      ['published', 'cds_error'].include? new_status
    end
  end
end
