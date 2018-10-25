module Quotas
  class RemoveSuspensionSaver
    attr_accessor :current_admin,
                  :workbasket,
                  :workbasket_settings,
                  :quota_definition

    def initialize(current_admin, workbasket, settings_ops={})
      @current_admin = current_admin
      @workbasket = workbasket
      @workbasket_settings = workbasket.settings
      @quota_definition = workbasket_settings.quota_definition
    end

    def valid?
      workbasket_settings.configure_step_settings['start_date'].present?
    end

    def persist!
      suspension_period = quota_definition.last_suspension_period
      if suspension_period.present?
        suspension_period.suspension_end_date = (operation_date - 1.day).midnight
        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            suspension_period, system_ops.merge(operation: "U")
        ).assign!
        suspension_period.save

        QuotaUnsuspensionEvent.unrestrict_primary_key
        record = QuotaUnsuspensionEvent.new({
                                               quota_definition_sid: workbasket_settings.initial_quota_sid,
                                               occurrence_timestamp: operation_date,
                                               unsuspension_date: operation_date
                                           })
        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            record, system_ops
        ).assign!
        record.save
      end
    end

    def success_response
      {}
    end

    def error_response
      {}
    end

    private

    def operation_date
      workbasket_settings.configure_step_settings['start_date'].try(:to_date)
    end

    def system_ops
      {
          operation_date: operation_date,
          current_admin_id: current_admin.id,
          workbasket_id: workbasket.id,
          status: "awaiting_cross_check"
      }
    end

  end
end