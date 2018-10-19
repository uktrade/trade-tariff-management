module Workbaskets
  class EditFootnoteSettings < Sequel::Model(:edit_footnotes_workbasket_settings)

    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
        Footnote
        FootnoteDescriptionPeriod
        FootnoteDescription
      )
    end

    def settings
      JSON.parse(main_step_settings_jsonb)
    end

    def measure_sids_jsonb
      '{}'
    end
  end
end
