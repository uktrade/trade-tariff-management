module Workbaskets
  module MeasureAssociationSavers
    class Base

      DEFAULT_LANGUAGE = "EN"

      private

        def set_primary_key(record)
          ::Workbaskets::Shared::PrimaryKeyGenerator.new(record)
        end
    end
  end
end
