module Workbaskets
  module Workflows
    class ApprovesController < Workbaskets::Workflows::BaseController
      # before_action :require_to_be_approver!, only: [:create, :show]
      # before_action :require_approve_not_to_be_aready_started!, only: [:new]
      # before_action :check_approve_permissions!, only: [:create, :show]

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
          redirect_to read_only_url
          false
        end
      end

      def require_approve_not_to_be_aready_started!
        if workbasket.approve_process_can_not_be_started? &&
            !workbasket.can_continue_approve?(current_user)
          redirect_to read_only_url
          false
        end
      end

      def check_approve_permissions!
        unless workbasket.approver_is?(current_user)
          redirect_to read_only_url
          false
        end
      end
    end
  end
end
