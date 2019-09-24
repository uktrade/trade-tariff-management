module WorkbasketValueObjects
  module EditRegulation
    class AttributesParser
      SIMPLE_OPS = %i(
        reason_for_changes
        base_regulation_id
        legal_id
        reference_url
        description
        validity_start_date
        validity_end_date
        regulation_group_id
      ).freeze

      attr_accessor :settings

      def initialize(settings, _current_step)
        @settings = settings
      end

      SIMPLE_OPS.map do |option_name|
        define_method(option_name) do
          settings[option_name]
        end
      end

      def start_date_formatted
        date_to_format(settings[:validity_start_date])
      end

      def end_date_formatted
        date_to_format(settings[:validity_end_date])
      end

      def date_to_format(date)
        date.try(:to_date)
          .try(:strftime, "%d %B %Y")
      end
    end
  end
end
