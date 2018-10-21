module WorkbasketValueObjects
  module CreateFootnote
    class AttributesParser

      SIMPLE_OPS = %w(
        footnote_type_id
        description
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

      def commodity_codes
        return [] if settings[:commodity_codes].blank?
        parse_list_of_values(settings[:commodity_codes])
      end

      def measure_sids
        return [] if settings[:measure_sids].blank?
        parse_list_of_values(settings[:measure_sids])
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

      def parse_list_of_values(list_of_ids)
        # Split by linebreaks
        linebreaks_separated_list = list_of_ids.split(/\n+/)

        # Split by commas
        comma_separated_list = linebreaks_separated_list.map do |item|
          item.split(",")
        end.flatten

        # Split by whitespaces
        white_space_separated_list = comma_separated_list.map do |item|
          item.split(" ")
        end.flatten

        white_space_separated_list.map(&:squish)
                                  .flatten
                                  .reject { |i| i.blank? }.uniq
      end
    end
  end
end
