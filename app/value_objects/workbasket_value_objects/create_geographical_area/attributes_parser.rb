module WorkbasketValueObjects
  module CreateGeographicalArea
    class AttributesParser

      SIMPLE_OPS = %w(
        geographical_code
        geographical_area_id
        parent_geographical_area_group_id
        description
        validity_start_date
        validity_end_date
        operation_date
      )

      attr_accessor :settings

      def initialize(settings)
        @settings = settings
      end

      SIMPLE_OPS.map do |option_name|
        define_method(option_name) do
          settings[option_name]
        end
      end

      def parent_geographical_area_group
        GeographicalArea.actual
                        .groups
                        .where(geographical_area_id: parent_geographical_area_group_id)
                        .first
      end

      def parent_geographical_area_group_sid
        parent_geographical_area_group.geographical_area_sid
      end

      def operation_date
        operation_date.try(:to_date)
      end
    end
  end
end
