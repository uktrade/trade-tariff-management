module WorkbasketHelpers
  module SettingsSaverHelperMethods
    extend ActiveSupport::Concern

    def current_admin
      workbasket.user
    end

    def errors_translator(key)
      I18n.t(
        self.class::WORKBASKET_TYPE.titleize
                                   .gsub(' ', '_')
                                   .downcase
      )[:errors][key]
    end

    def clear_cached_sequence_number!
      Rails.cache.delete("#{workbasket.id}_sequence_number")
    end

    def system_ops
      {
        workbasket_id: workbasket.id,
        operation_date: operation_date,
        current_admin_id: current_admin.id
      }
    end

    def assign_system_ops!(measure)
      system_ops_assigner = ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
        measure, system_ops
      )
      system_ops_assigner.assign!

      system_ops_assigner.record
    end
  end
end
