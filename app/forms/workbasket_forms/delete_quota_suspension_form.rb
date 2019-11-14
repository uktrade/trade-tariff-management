module WorkbasketForms
  class DeleteQuotaSuspensionForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ::WorkbasketHelpers::SettingsSaverHelperMethods

    attr_accessor :workbasket,
                  :settings_errors,
                  :workbasket_title,
                  :reason_for_changes,
                  :quota_suspension_period_sid,
                  :quota_association

    def initialize(settings: {}, current_user: nil)
      byebug
      @workbasket_title =  settings[:workbasket_title]
      @reason_for_changes = settings[:reason_for_changes]
      @quota_suspension_period_sid = settings[:quota_suspension_period_sid]
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

      quota_suspension = QuotaSuspensionPeriod.find(quota_suspension_period_sid: @quota_suspension_period_sid)

      if @settings_errors.empty?
        @workbasket = Workbaskets::Workbasket.create(
          title: @workbasket_title,
          status: :new_in_progress,
          type: :delete_quota_association,
          user: @current_user
        )

        byebug

        @workbasket.settings.update(main_quota_definition_sid: @main_quota_definition_sid,
                                    sub_quota_definition_sid: @sub_quota_definition_sid
        )

        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
          association, system_ops.merge(operation: "D")
        ).assign!(false)

        association.save

        workbasket.submit_for_cross_check!(current_admin: current_admin)

      end

      @settings_errors.empty?
    end
  end
end
