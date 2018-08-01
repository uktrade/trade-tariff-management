module Workbaskets
  module CreateMeasures
    class SettingsSaver < ::Workbaskets::SettingsSaverBase

      workbasket_type = "CreateMeasures"

      class << self
        def associations_list
          %w(
            measure_components
            conditions
            footnotes
            excluded_geographical_areas
          )
        end
      end
    end
  end
end
