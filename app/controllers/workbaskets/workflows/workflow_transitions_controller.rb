module Workbaskets
  module Workflows
    class WorkflowTransitionsController < Workbaskets::Workflows::BaseController
      # before_action :check_permissions!, only: [:submit_for_approval]

      def submit_for_approval
        workbasket.move_status_to!(current_user, :awaiting_approval)

        redirect_to read_only_url
      end

    private

      def check_permissions!
        unless current_user.author_of_workbasket?(workbasket) || current_user.approver? || workbasket.cross_checker_is?(current_user)
          redirect_to read_only_url
          false
        end
      end
    end
  end
end
