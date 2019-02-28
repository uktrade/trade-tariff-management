module Workbaskets
  module Workflows
    class ApprovesController < Workbaskets::Workflows::BaseController
      before_action :require_to_be_approver!
      # before_action :require_approve_not_to_be_aready_started!, only: [:new]

      expose(:checker) do
        ::WorkbasketInteractions::Workflow::Approve.new(
          current_user, workbasket, params[:approve]
        )
      end

      expose(:check_completed_url) do
        approve_url(workbasket.id)
      end

    private

      def require_to_be_approver!
        unless current_user.approver?
          redirect_to root_path
          false
        end
      end

      def require_approve_not_to_be_aready_started!
        if workbasket.approve_process_can_not_be_started? &&
            !workbasket.awaiting_approval?
          redirect_to read_only_url
          false
        end
      end

    end
  end
end
