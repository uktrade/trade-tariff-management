module Workbaskets
  class ApprovesController < Workbaskets::WorkflowBaseController

    before_action :require_to_be_approver!
    before_action :require_approve_not_to_be_aready_started!, only: [:new]
    before_action :check_approve_permissions!, only: [:create, :show]

    expose(:checker) do
      ::WorkbasketInteractions::Workflow::Approve.new(
        current_user, workbasket, params[:approve]
      )
    end

    expose(:check_completed_url) do
      approve_url(workbasket.id)
    end

    def new
      workbasket.assign_approver!(current_user)
    end

    private

      def require_to_be_approver!
        unless current_user.approver?
          redirect_url read_only_url
          return false
        end
      end

      def require_approve_not_to_be_aready_started!
        unless workbasket.approve_process_can_be_started?
          redirect_url read_only_url
          return false
        end
      end

      def check_approve_permissions!
        unless workbasket.approver_id == current_user.id
          redirect_url read_only_url
          return false
        end
      end
  end
end
