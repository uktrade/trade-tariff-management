module WorkbasketValueObjects
  module EditNomenclature
    class AttributesParser
      SIMPLE_OPS = %w(
        description
      ).freeze

      attr_accessor :settings

      def initialize(settings)
        @settings = settings
      end

      SIMPLE_OPS.map do |option_name|
        define_method(option_name) do
          settings[option_name]
        end
      end

    end
  end
end
