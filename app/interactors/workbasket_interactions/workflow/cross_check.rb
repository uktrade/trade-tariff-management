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
        if workbasket.settings.try(:quota_period_sids)
          workbasket.settings.quota_period_sids.each do |sid|
            quota = QuotaDefinition.find(quota_definition_sid: sid)
            quota.status = "awaiting_approval"
            quota.save
          end
        end
      end

      def post_reject_action!
        workbasket.cross_checker_id = nil
        workbasket.save
        workbasket.settings.measure_sids.each do |sid|
          measure = Measure.find(measure_sid: sid)
          measure.status = "cross_check_rejected"
          measure.save
        end
        if workbasket.settings.try(:quota_period_sids)
          workbasket.settings.quota_period_sids.each do |sid|
            quota = QuotaDefinition.find(quota_definition_sid: sid)
            quota.status = "cross_check_rejected"
            quota.save
          end
        end
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
