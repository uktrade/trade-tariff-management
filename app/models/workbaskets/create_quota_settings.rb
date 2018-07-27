module Workbaskets
  class CreateQuotaSettings < Sequel::Model(:create_quota_workbasket_settings)

    include ::WorkbasketHelpers::SettingsBase

  end
end
