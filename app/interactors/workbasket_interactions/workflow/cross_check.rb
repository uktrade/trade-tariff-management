module WorkbasketInteractions
  module Workflow
    class CrossCheck < ::WorkbasketInteractions::Workflow::ApproveBase
    private

      def post_approve_action!
        if submit_for_approval.present?
          workbasket.move_status_to!(
            current_user,
            :awaiting_approval
          )
        end
      end

      def post_reject_action!
        workbasket.cross_checker_id = nil
        workbasket.save
      end

      def approve_status
        :ready_for_approval
      end

      def reject_status
        :cross_check_rejected
      end

      def blank_mode_validation_message
        :cross_check_mode_blank
      end
    end
  end
end
