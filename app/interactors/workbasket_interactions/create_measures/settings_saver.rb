module WorkbasketInteractions
  module CreateMeasures
    class SettingsSaver < ::WorkbasketInteractions::SettingsSaverBase

      WORKBASKET_TYPE = "CreateMeasures"

      ASSOCIATION_LIST = %w(
        measure_components
        conditions
        footnotes
        excluded_geographical_areas
      )

      ASSOCIATION_LIST.map do |name|
        define_method("#{name}_errors") do |measure|
          get_association_errors(name, measure)
        end
      end
    end
  end
end
