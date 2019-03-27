module WorkbasketInteractions
  module Workflow
    class Approve < ::WorkbasketInteractions::Workflow::ApproveBase
    private

      def post_approve_action!
        if export_date.present?
          workbasket.operation_date = export_date.to_date
          workbasket.save
        end
        workbasket.settings.measure_sids.each do |sid|
          measure = Measure.find(measure_sid: sid)
          measure.status = if workbasket.type == "bulk_edit_of_measures"
            "awaiting_cds_upload_edit"
          else
            "awaiting_cds_upload_create_new"
          end
          measure.save
        end
        if workbasket.settings.try(:quota_period_sids)
          workbasket.settings.quota_period_sids.each do |sid|
            quota = QuotaDefinition.find(quota_definition_sid: sid)
            quota.status = "awaiting_cds_upload_create_new"
            quota.save
          end
        end
      end

      def post_reject_action!
        workbasket.approver_id = nil
        workbasket.save
        workbasket.settings.measure_sids.each do |sid|
          measure = Measure.find(measure_sid: sid)
          measure.status = "approval_rejected"
          measure.save
        end
        if workbasket.settings.try(:quota_period_sids)
          workbasket.settings.quota_period_sids.each do |sid|
            quota = QuotaDefinition.find(quota_definition_sid: sid)
            quota.status = "approval_rejected"
            quota.save
          end
        end
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
