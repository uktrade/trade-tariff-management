module WorkbasketInteractions
  module Workflow
    class Approve < ::WorkbasketInteractions::Workflow::ApproveBase
    private

      def post_approve_action!
        if export_date.present?
          workbasket.operation_date = export_date.to_date
          workbasket.save
        end
      end

      def post_reject_action!
        workbasket.approver_id = nil
        workbasket.save
      end

      def approve_status
        if export_date.present?
          workbasket.possible_approved_status
        else
          :ready_for_export
        end
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
