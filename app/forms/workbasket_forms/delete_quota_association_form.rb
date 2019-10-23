module WorkbasketForms
  class DeleteQuotaAssociationForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ::WorkbasketHelpers::SettingsSaverHelperMethods

    attr_accessor :workbasket,
                  :settings_errors,
                  :workbasket_title,
                  :reason_for_changes,
                  :main_quota_definition_sid,
                  :sub_quota_definition_sid,
                  :main_quota_definition,
                  :sub_quota_definition,
                  :quota_association

    def initialize(settings: {}, current_user: nil)
      @workbasket_title =  settings[:workbasket_title]
      @reason_for_changes = settings[:reason_for_changes]
      @main_quota_definition_sid = settings[:main_quota_definition_sid]
      @sub_quota_definition_sid = settings[:sub_quota_definition_sid]
      @current_user = current_user
      @settings_errors = {}
    end

    def create
      if @workbasket_title.empty?
        @settings_errors[:workbasket_title] = "Workbasket title must be entered"
      end

      quota_association = QuotaAssociation.find(main_quota_definition_sid: @main_quota_definition_sid,
                                                sub_quota_definition_sid: @sub_quota_definition_sid,)
      if quota_association.nil?
        @settings_errors[:general] = "Couldn't find quota association"
      elsif quota_association.main_quota_definition.validity_start_date <= Date.today
        @settings_errors[:main_quota_definition_sid] = "Cannot delete an association where the parent quota order has started"
      end

      if @settings_errors.empty?
        @workbasket = Workbaskets::Workbasket.create(
          title: @workbasket_title,
          status: :new_in_progress,
          type: :delete_quota_association,
          user: @current_user
        )

        @workbasket.settings.update(main_quota_definition_sid: @main_quota_definition_sid,
                                    sub_quota_definition_sid: @sub_quota_definition_sid
        )

        association = QuotaAssociation.find(
          main_quota_definition_sid: @workbasket.settings.main_quota_definition_sid,
          sub_quota_definition_sid: @workbasket.settings.sub_quota_definition_sid
        )

        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
          association, system_ops.merge(operation: "D")
        ).assign!(false)

        association.destroy

        workbasket.submit_for_cross_check!(current_admin: current_admin)

      end

      @settings_errors.empty?
    end

    def main_quota_definition
      @main_quota_definition ||= QuotaDefinition.find(quota_definition_sid: main_quota_definition_sid)
    end

    def sub_quota_definition
      @sub_quota_definition ||= QuotaDefinition.find(quota_definition_sid: sub_quota_definition_sid)
    end

    def quota_association
      @quota_association ||= QuotaAssociation.find(main_quota_definition_sid: main_quota_definition_sid,
                                                   sub_quota_definition_sid: sub_quota_definition_sid)
    end
  end
end
