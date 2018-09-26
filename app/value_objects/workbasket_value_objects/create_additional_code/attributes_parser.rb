module WorkbasketValueObjects
  module CreateAdditionalCode
    class AttributesParser < WorkbasketValueObjects::AttributesParserBase

      SIMPLE_OPS = %w(
      )

      SIMPLE_OPS.map do |option_name|
        define_method(option_name) do
          ops[option_name]
        end
      end

      attr_accessor :ops

      def initialize(workbasket_settings, step, ops = nil)
        @workbasket_settings = workbasket_settings
        @step = step
        @ops = ops
      end
    end
  end
end
