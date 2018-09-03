module WorkbasketInteractions
  module CreateRegulation
    class SettingsSaver < ::WorkbasketInteractions::SettingsSaverBase

      WORKBASKET_TYPE = "CreateRegulation"

      ATTRS_PARSER_METHODS = %w(
        workbasket_name
      )

    end
  end
end
