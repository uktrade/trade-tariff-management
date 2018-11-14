module WorkbasketValueObjects
  module EditGeographicalArea
    class AttributesParser

      SIMPLE_OPS = %w(
        description
        parent_geographical_area_group_id
        remove_parent_group_association
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
        if parent_geographical_area_group_id.present?
          GeographicalArea.actual
                          .groups
                          .where(geographical_area_id: parent_geographical_area_group_id)
                          .first
        end
      end

      def parent_geographical_area_group_sid
        parent_geographical_area_group.try(:geographical_area_sid)
      end

      def validity_start_date
        to_date(:validity_start_date)
      end

      def validity_end_date
        to_date(:validity_end_date)
      end

      def operation_date
        to_date(:operation_date)
      end

      def description_validity_start_date
        to_date(:description_validity_start_date)
      end

      def operation_date_formatted
        date_to_format(ops[:operation_date])
      end

      def start_date_formatted
        date_to_format(ops[:start_date])
      end

      def end_date_formatted
        ops[:end_date].present? ? date_to_format(ops[:end_date]) : "-"
      end

      def to_date(param_name)
        settings[param_name].try(:to_date)
      end

      def date_to_format(date)
        date.try(:to_date)
            .try(:strftime, "%d %B %Y")
      end
    end
  end
end

