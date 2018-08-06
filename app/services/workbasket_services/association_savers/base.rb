module WorkbasketServices
  module AssociationSavers
    class Base

      DEFAULT_LANGUAGE = "EN"

      private

        def set_primary_key(record)
          ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(record)
        end
    end
  end
end
