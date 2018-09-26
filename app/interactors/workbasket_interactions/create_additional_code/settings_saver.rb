module WorkbasketInteractions
  module CreateAdditionalCode
    class SettingsSaver < ::WorkbasketInteractions::SettingsSaverBase

      WORKBASKET_TYPE = "CreateAdditionalCode"

      ATTRS_PARSER_METHODS = %w(
      )

      def valid?
        true
      end

      def persist!
      end

    end
  end
end
