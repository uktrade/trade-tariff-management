module WorkbasketForms
  class DeleteQuotaBlockingPeriodForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ::WorkbasketHelpers::SettingsSaverHelperMethods

    attr_accessor :workbasket,
                  :settings_errors,
                  :workbasket_title,
                  :reason_for_changes,
                  :quota_blocking_period_sid

    def initialize(settings: {}, current_user: nil)
      @workbasket_title =  settings[:workbasket_title]
      @reason_for_changes = settings[:reason_for_changes]
      @quota_blocking_period_sid = settings[:quota_blocking_period_sid]
      @current_user = current_user
      @settings_errors = {}
    end

    def save
      if @workbasket_title.empty?
        @settings_errors[:workbasket_title] = "Workbasket title must be entered"
      end

      if @reason_for_changes.empty?
        @settings_errors[:workbasket_title] = "Workbasket title must be entered"
      end

      quota_blocking_period = QuotaBlockingPeriod.find(quota_blocking_period_sid: @quota_blocking_period_sid)

      if @settings_errors.empty?
        @workbasket = Workbaskets::Workbasket.create(
          title: @workbasket_title,
          status: :new_in_progress,
          type: :delete_quota_blocking_period,
          user: @current_user
        )


        @workbasket.settings.update(quota_blocking_period_sid: @quota_blocking_period_sid)

        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
          quota_blocking_period, system_ops.merge(operation: "D")
        ).assign!(false)

        quota_blocking_period.save

        workbasket.submit_for_cross_check!(current_admin: current_admin)

      end

      @settings_errors.empty?
    end
  end

  def system_ops
    {
      current_admin_id: current_admin.id,
      workbasket_id: workbasket.id,
      status: "awaiting_cross_check"
    }
  end
end
