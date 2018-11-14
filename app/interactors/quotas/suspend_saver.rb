module Quotas
  class SuspendSaver

    attr_accessor :current_admin,
                  :workbasket,
                  :workbasket_settings

    def initialize(current_admin, workbasket, settings_ops={})
      @current_admin = current_admin
      @workbasket = workbasket
      @workbasket_settings = workbasket.settings
    end

    def valid?
      workbasket_settings.configure_step_settings['start_date'].present?
    end

    def persist!
      record = QuotaSuspensionPeriod.new({
                                    quota_definition_sid: workbasket_settings.initial_quota_sid,
                                    suspension_start_date: operation_date,
                                    suspension_end_date: workbasket_settings.configure_step_settings['suspension_date'].try(:to_date),
                                    description: workbasket_settings.configure_step_settings['reason']
                                })
      ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(record).assign!
      ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
          record, system_ops
      ).assign!
      record.save
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
