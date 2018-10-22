module Workbaskets
  class CreateFootnoteSettings < Sequel::Model(:create_footnotes_workbasket_settings)

    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
        Footnote
        FootnoteDescriptionPeriod
        FootnoteDescription
        FootnoteAssociationMeasure
        FootnoteAssociationGoodsNomenclature
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
