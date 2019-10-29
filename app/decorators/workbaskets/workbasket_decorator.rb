module Workbaskets
  class WorkbasketDecorator < ApplicationDecorator
    def type
      case object.type
      when "create_measures"
        "Create Measures"
      when "bulk_edit_of_measures"
        "Bulk Edit of Measures"
      when "create_quota"
        "Create Quota"
      when "clone_quota"
        "Clone Quota"
      when "create_regulation"
        "Create Regulation"
      when "create_additional_code"
        "Create Additional Codes"
      when "bulk_edit_of_additional_codes"
        "Bulk Edit of Additional Codes"
      when "bulk_edit_of_quotas"
        "Edit of Quota" + (object.settings.workbasket_action.present? ? " (#{object.settings.workbasket_action.tr('_', ' ')})" : '')
      when "create_geographical_area"
        "Create Geographical Area"
      when "create_footnote"
        "Create Footnote"
      when "create_certificate"
        "Create Certificate"
      when "edit_footnote"
        "Edit footnote"
      when "edit_certificate"
        "Edit Certificate"
      when "edit_geographical_area"
        "Edit Geographical Area"
      when "create_nomenclature"
        "Create Goods Classification"
      when "edit_nomenclature"
        "Edit Goods Classification"
      when "edit_regulation"
        "Edit Regulation"
      when "create_quota_association"
        "Create Quota Association"
      when "delete_quota_association"
        "Delete Quota Association"
      when "create_quota_suspension"
        "Create Quota Suspension Period"
      when "edit_quota_suspension"
        "Edit Quota Suspension Period"
      end
    end

    def status
      case object.status.to_sym
      when :new_in_progress
        "New - in progress"
      when :editing
        "Editing"
      when :awaiting_cross_check
        "Awaiting cross-check"
      when :cross_check_rejected
        "Failed cross-check"
      when :awaiting_approval
        "Awaiting approval"
      when :approval_rejected
        "Failed approval"
      when :ready_for_export
        "Ready for export"
      when :awaiting_cds_upload_create_new
        "Awaiting CDS upload - create new"
      when :awaiting_cds_upload_edit
        "Awaiting CDS upload - edit"
      when :awaiting_cds_upload_overwrite
        "Awaiting CDS upload - overwrite"
      when :awaiting_cds_upload_delete
        "Awaiting CDS upload - delete"
      when :sent_to_cds
        "Sent to CDS"
      when :sent_to_cds_delete
        "Sent to CDS - delete"
      when :published
        "Published"
      when :cds_error
        "CDS error"
      end
    end

    def status_with_error?
      object.class::STATES_WITH_ERROR.include?(object.status.to_sym)
    end

    def last_event_at
      (object.last_status_change_at || object.created_at).strftime("%d %b %Y")
    end
  end
end
