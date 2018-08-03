module Workbaskets
  module CreateQuota
    class SettingsSaver < ::Workbaskets::SettingsSaverBase

      WORKBASKET_TYPE = "CreateQuota"

      ASSOCIATION_LIST = %w(
        quota_periods
        conditions
        footnotes
        excluded_geographical_areas
      )

      ::ASSOCIATION_LIST.map do |name|
        define_method("#{name}_errors") do |measure|
          association_errors(name)
        end
      end
    end
  end
end
