module WorkbasketValueObjects
  module CreateRegulation
    class AttributesParser < WorkbasketValueObjects::AttributesParserBase

      SIMPLE_OPS = %w(
        operation_date
        prefix
        publication_year
        regulation_number
        number_suffix
      )

      SIMPLE_OPS.map do |option_name|
        define_method(option_name) do
          ops[option_name]
        end
      end

      def initialize(workbasket_settings, step, ops = nil)
        @workbasket_settings = workbasket_settings
        @step = step
        @ops = ops.present? ?
                   ops :
                   ActiveSupport::HashWithIndifferentAccess.new(
                       workbasket_settings.settings
                   )
      end

      def fetch_regulation_number
        base = "#{prefix}#{publication_year}#{regulation_number}"
        base += number_suffix.to_s
        base.delete(' ')
      end

      def workbasket_name
        "Create Regulation #{fetch_regulation_number}"
      end

    end
  end
end
