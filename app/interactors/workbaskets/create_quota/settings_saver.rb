module Workbaskets
  module CreateQuota
    class SettingsSaver < ::Workbaskets::SettingsSaverBase

      workbasket_type = "CreateQuota"

      class << self
        def associations_list
          %w(
            quota_periods
            conditions
            footnotes
            excluded_geographical_areas
          )
        end
      end
    end
  end
end
