module WorkbasketInteractions
  module Workflow
    class CrossCheck < ::WorkbasketInteractions::Workflow::ApproveBase
    private

      def post_approve_action!
        workbasket.move_status_to!(
          current_user,
          :awaiting_approval
        )
        workbasket.settings.measure_sids.each do |sid|
          measure = Measure.find(measure_sid: sid)
          measure.status = "awaiting_approval"
          measure.save
        end
      end

      def post_reject_action!
        workbasket.cross_checker_id = nil
        workbasket.save
      end

      def approve_status
        :awaiting_approval
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
