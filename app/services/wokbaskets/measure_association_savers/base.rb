module CreateMeasures
  module ValidationHelpers
    class Base

      DEFAULT_LANGUAGE = "EN"

      private

        def set_primary_key(record)
          PrimaryKeyGenerator.new(record)
        end
    end
  end
end
