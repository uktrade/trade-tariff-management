module WorkbasketInteractions
  module Workflow
    class Approve < ::WorkbasketInteractions::Workflow::ApproveBase
    private

      def post_approve_action!
        workbasket.confirm_approval!(current_admin: current_user)
      end

      def post_reject_action!
        workbasket.reject_approval!(current_admin: current_user)
      end

      def approve_status
        workbasket.possible_approved_status
      end

      def reject_status
        :approval_rejected
      end

      def blank_mode_validation_message
        :approve_mode_blank
      end
    end
  end
end
